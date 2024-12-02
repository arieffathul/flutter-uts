part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileStateLoading extends ProfileState {}

final class ProfileStateLoaded extends ProfileState {
  final UserModel userModel;

  ProfileStateLoaded({required this.userModel}); // Ubah menjadi named parameter
}

class ProfileStateUpdated extends ProfileState {
  final String message;

  ProfileStateUpdated({required this.message});
}

final class ProfileStateError extends ProfileState {
  final String message;

  ProfileStateError(String string,
      {required this.message}); // Ubah menjadi named parameter saja
}
