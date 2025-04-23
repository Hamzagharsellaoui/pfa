abstract class DoctorDetailEvent {}

class FetchDoctorDetail extends DoctorDetailEvent {
  final int doctorId;

  FetchDoctorDetail(this.doctorId);
}
