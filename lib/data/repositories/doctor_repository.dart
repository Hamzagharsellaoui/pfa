import '../models/doctor.dart';

class DoctorRepository {
  Future<Doctor> fetchDoctorDetail(String doctorId) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    return Doctor(
      id: doctorId,
      name: "Dr. Tarek Frikha",
      image: "assets/images/frikh-3379374-small.gif",
      specialty: "Cardiologist",
    );
  }
}
