import 'package:bloc/bloc.dart';
import '../../../data/repositories/ConfigureContract1.dart'; // Assuming DoctorInfo is defined here or adjust path

part 'doctor_list_event.dart';
part 'doctor_list_state.dart';

class DoctorListBloc extends Bloc<DoctorListEvent, DoctorListState> {
  final ConfigureContract contract;

  DoctorListBloc({required this.contract}) : super(DoctorListInitial()) {
    on<FetchDoctors>(_onFetchDoctors);
  }

  Future<void> _onFetchDoctors(FetchDoctors event, Emitter<DoctorListState> emit) async {
    emit(DoctorListLoading());
    try {
      final List<DoctorInfo> doctors = await contract.getAllDoctors();
      emit(DoctorListLoaded(doctors));
    } catch (e) {
      emit(DoctorListError('Error loading doctors: $e'));
    }
  }
}