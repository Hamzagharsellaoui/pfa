part of 'doctor_list_bloc.dart';

abstract class DoctorListState {}

class DoctorListInitial extends DoctorListState {}

class DoctorListLoading extends DoctorListState {}

class DoctorListLoaded extends DoctorListState {
  final List<DoctorInfo> doctors;

  DoctorListLoaded(this.doctors);
}

class DoctorListError extends DoctorListState {
  final String error;

  DoctorListError(this.error);
}