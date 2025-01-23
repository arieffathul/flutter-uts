import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:uts_warteg/models/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ProfileBloc() : super(ProfileInitial()) {
    firestore.collection('users');
    on<ProfileEventGet>((event, emit) async {
      try {
        // Ketika login dijalankan, loading state emit
        emit(ProfileStateLoading());
        // fungsi tampilan

        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await firestore.collection('users').doc(event.uid).get();
        Map<String, dynamic>? user = userDoc.data();
        // cek ada atau tidak
        if (user != null) {
          // jika ada kita masukkan ke model
          emit(ProfileStateLoaded(userModel: UserModel.fromJson(user)));
        } else {
          // error jika tidak ada data user
          emit(ProfileStateError('', message: 'user not found'));
        }
      } on FirebaseException catch (e) {
        String errorMessage;

        // Cek tipe error berdasarkan kode
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Pengguna dengan email tersebut tidak ditemukan.';
            break;
          case 'wrong-password':
            errorMessage = 'Kata sandi yang dimasukkan salah.';
            break;
          case 'invalid-email':
            errorMessage = 'Format email tidak valid.';
            break;
          // case 'user-disabled':
          //   errorMessage = 'Akun ini telah dinonaktifkan oleh administrator.';
          //   break;
          default:
            errorMessage = 'Terjadi kesalahan saat login. Silakan coba lagi.';
            break;
        }

        emit(ProfileStateError(e.message.toString(), message: errorMessage));
      } catch (e) {
        emit(ProfileStateError(e.toString(), message: 'kesalahan tak terduga'));
      }
    });
    on<ProfileEventUpdate>((event, emit) async {
      try {
        // Emit state loading
        emit(ProfileStateLoading());

        // Update data di Firestore
        await firestore
            .collection('users')
            .doc(event.uid)
            .update(event.updatedData);

        // Emit state berhasil
        emit(ProfileStateUpdated(message: 'Profil berhasil diperbarui.'));
      } on FirebaseException catch (e) {
        emit(ProfileStateError(
          e.code,
          message: 'Gagal memperbarui profil: ${e.message}',
        ));
      } catch (e) {
        emit(
            ProfileStateError(e.toString(), message: 'Kesalahan tak terduga.'));
      }
    });
  }
}
