abstract class ProfileImageEvent {}

class LoadProfileImageEvent extends ProfileImageEvent {
  final String userId;
  LoadProfileImageEvent(this.userId);
}

class UpdateProfileImageEvent extends ProfileImageEvent {
  final String userId;
  UpdateProfileImageEvent(this.userId);
}