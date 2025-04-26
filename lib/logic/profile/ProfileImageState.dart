import 'dart:io';

abstract class ProfileImageState {}

class ProfileImageInitial extends ProfileImageState {}

class ProfileImageLoading extends ProfileImageState {}

class ProfileImageLoaded extends ProfileImageState {
  final File imageFile;
  ProfileImageLoaded(this.imageFile);
}

class ProfileImageError extends ProfileImageState {
  final String error;
  ProfileImageError(this.error);
}