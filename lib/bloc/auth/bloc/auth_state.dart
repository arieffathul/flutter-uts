part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoaded extends AuthState {}

final class AuthLogout extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError(String string, {required this.message});
}
