import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/imageRepo.dart';
import 'ProfileImageEvent.dart';
import 'ProfileImageState.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  final Imagerepo imageRepo;

  ProfileImageBloc(this.imageRepo) : super(ProfileImageInitial()) {
    on<LoadProfileImageEvent>(_onLoadProfileImage);
    on<UpdateProfileImageEvent>(_onUpdateProfileImage);
  }

  Future<void> _onLoadProfileImage(LoadProfileImageEvent event, Emitter<ProfileImageState> emit) async {
    emit(ProfileImageLoading());
    try {
      final imageFile = await imageRepo.getProfileImage(event.userId);
      if (imageFile != null) {
        emit(ProfileImageLoaded(imageFile));
      } else {
        emit(ProfileImageError('Failed to load profile image'));
      }
    } catch (e) {
      emit(ProfileImageError('Error loading profile image: $e'));
    }
  }

  Future<void> _onUpdateProfileImage(UpdateProfileImageEvent event, Emitter<ProfileImageState> emit) async {
    emit(ProfileImageLoading());
    try {
      await imageRepo.clearProfileImageCache(event.userId);
      final imageFile = await imageRepo.getProfileImage(event.userId);
      if (imageFile != null) {
        emit(ProfileImageLoaded(imageFile));
      } else {
        emit(ProfileImageError('Failed to update profile image'));
      }
    } catch (e) {
      emit(ProfileImageError('Error updating profile image: $e'));
    }
  }
}