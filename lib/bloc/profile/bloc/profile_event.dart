part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileEventGet extends ProfileEvent {
  final String uid;

  ProfileEventGet({required this.uid});
}

class ProfileEventUpdate extends ProfileEvent {
  final String uid;
  final Map<String, dynamic> updatedData;

  ProfileEventUpdate({required this.uid, required this.updatedData});
}
