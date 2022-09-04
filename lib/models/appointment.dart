import 'package:pss/models/bio_doctor.dart';
import 'package:pss/models/bio_patient.dart';

class Appointment {
  final int id;
  final int createdBy;
  final BioDoctor doctor;
  final BioPatient patient;
  final String status;
  final DateTime dateTime;
  final String? description;
  final DateTime createdOn;
  final DateTime scheduledOn;
  final DateTime? cancelledOn;
  final DateTime? confirmedOn;

  Appointment(
      {required this.id,
      required this.createdBy,
      required this.doctor,
      required this.patient,
      required this.status,
      required this.dateTime,
      required this.description,
      required this.createdOn,
      required this.scheduledOn,
      required this.cancelledOn,
      required this.confirmedOn});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json["id"],
        createdBy: json["created_by"]["id"],
        doctor: BioDoctor.fromJson(json["doctor"]),
        patient: BioPatient.fromJson(json["patient"]),
        status: json["status"],
        dateTime: DateTime.parse(
          json["datetime"],
        ),
        description: json["description"],
        createdOn: DateTime.parse(json["created_on"]),
        scheduledOn: DateTime.parse(json["scheduled_on"]),
        cancelledOn: json["cancelled_on"] == null
            ? null
            : DateTime.parse(json["cancelled_on"]),
        confirmedOn: json["confirmed_on"] == null
            ? null
            : DateTime.parse(json["confirmed_on"]));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> appointment = {};
    appointment["id"] = id;
    appointment["created_by"] = createdBy;
    appointment["doctor"] = doctor;
    appointment["patient"] = patient;
    appointment["status"] = status;
    appointment["dateTime"] = dateTime;
    appointment["description"] = description;
    appointment["created_on"] = createdOn;
    appointment["scheduled_on"] = scheduledOn;
    appointment["cancelled_on"] = cancelledOn;
    appointment["confirmed_on"] = confirmedOn;

    return appointment;
  }
}

class AppointmentsListResult {
  // Class modelling response form getAppointments request

  final String? next;
  final String? previous;
  final List<Appointment> results;

  AppointmentsListResult({
    required this.next,
    required this.previous,
    required this.results,
  });

  factory AppointmentsListResult.fromJson(Map<String, dynamic> json) {
    return AppointmentsListResult(
      next: json["next"],
      previous: json["previous"],
      results: json["results"].length != 0
          ? List<Appointment>.from(
              json["results"].map((model) => Appointment.fromJson(model)))
          : <Appointment>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> appointments = <String, dynamic>{};
    appointments["next"] = next;
    appointments["previous"] = previous;
    appointments["results"] = List<Map<String, dynamic>>.from(results.map(
      (e) => e.toJson(),
    ));
    return appointments;
  }
}
