import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    on<AuthEvent>((event, emit) async {
      if (event is AuthEventLogin) {
        try {
          emit(AuthLoading());
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          await users.doc(userCredential.user!.uid).get().then((value) async {
            if (value.exists) {
              await users.doc(userCredential.user!.uid).update({
                'lastLoginAt': Timestamp.now(),
              });
            } else {
              await users.doc(userCredential.user!.uid).set({
                'email': userCredential.user!.email,
                'uid': userCredential.user!.uid,
                'name': userCredential.user!.displayName,
                'photoUrl': userCredential.user!.photoURL,
                'createdAt': Timestamp.now(),
                'lastLoginAt': Timestamp.now(),
              });
            }
          });

          emit(AuthLoaded());
        } on FirebaseAuthException catch (e) {
          String errorMessage;

          switch (e.code) {
            case 'user-not-found':
              errorMessage =
                  'Akun tidak ditemukan. Silahkan daftar terlebih dahulu.';
              break;
            case 'wrong-password':
              errorMessage = 'Kata sandi salah. Silahkan coba lagi.';
              break;
            case 'invalid-email':
              errorMessage = 'Email tidak valid. Silahkan coba lagi.';
              break;

            default:
              errorMessage = 'Terjadi Kesalahan. Silahkan coba lagi.';
              break;
          }

          emit(AuthError(e.message.toString(), message: errorMessage));
        } catch (e) {
          emit(AuthError(e.toString(), message: 'kesalahan tak terduga'));
        }
      }
      on<AuthEventLogout>(
        (event, emit) async {
          try {
            emit(AuthLoading());
            await auth.signOut();
            emit(AuthLogout());
          } on FirebaseAuthException catch (e) {
            emit(AuthError(e.message.toString(), message: 'gagal logout'));
          } catch (e) {
            emit(AuthError(e.toString(), message: 'gagal logout'));
          }
        },
      );
    });
  }
}
