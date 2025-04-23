import '../../data/models/doctor.dart'; // Adjust path if needed

abstract class DoctorDetailState {}

class DoctorDetailInitial extends DoctorDetailState {}

class DoctorDetailLoading extends DoctorDetailState {}

class DoctorDetailLoaded extends DoctorDetailState {
  final Doctor doctor; // Replace with your actual model

  DoctorDetailLoaded(this.doctor);
}

class DoctorDetailError extends DoctorDetailState {
  final String message;

  DoctorDetailError(this.message);
}
