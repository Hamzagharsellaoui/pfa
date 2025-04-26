import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_detail_event.dart';
import 'doctor_detail_state.dart';
import '../../data/models/doctor.dart'; // Adjust path
import '../../data/repositories/doctor_repository.dart'; // Create if not yet

class DoctorDetailBloc extends Bloc<DoctorDetailEvent, DoctorDetailState> {
  final DoctorRepository doctorRepository;

  DoctorDetailBloc(this.doctorRepository) : super(DoctorDetailInitial()) {
    on<FetchDoctorDetail>((event, emit) async {
      emit(DoctorDetailLoading());
      try {
        final doctor = await doctorRepository.fetchDoctorDetail(event.doctorId.toString());
        emit(DoctorDetailLoaded(doctor));
      } catch (e) {
        emit(DoctorDetailError("Failed to fetch doctor details"));
      }
    });
  }
}
