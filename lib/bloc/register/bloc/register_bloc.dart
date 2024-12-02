import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  RegisterBloc()
      : _firebaseAuth = FirebaseAuth.instance,
        _firebaseFirestore = FirebaseFirestore.instance,
        super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Simpan data pengguna ke Firestore
        await _firebaseFirestore
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'email': userCredential.user?.email ?? 'N/A',
          'uid': userCredential.user?.uid ?? '',
          'name': event.name,
          'photoUrl': userCredential.user?.photoURL ?? '',
          'createdAt': Timestamp.now(),
          'lastLoginAt': Timestamp.now(),
        });

        // Perbarui nama pengguna di FirebaseAuth
        await userCredential.user?.updateDisplayName(event.name);

        emit(RegisterSuccess());
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Register Gagal: ${e.message}';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email sudah terdaftar';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Email tidak valid';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password terlalu lemah';
        }
        emit(RegisterFailure(message: errorMessage));
      } catch (e) {
        emit(RegisterFailure(message: 'Kesalahan tidak terduga: $e'));
      }
    });
  }
}
