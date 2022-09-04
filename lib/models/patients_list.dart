import 'package:pss/models/bio_patient.dart';

class PatientsListResult {
  // Class modelling response form getPatients request

  final int count;
  final String? next;
  final String? previous;
  final List<BioPatient> results;

  PatientsListResult({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PatientsListResult.fromJson(Map<String, dynamic> json) {
    return PatientsListResult(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
      results: json["results"] != null
          ? List<BioPatient>.from(
              json["results"].map((model) => BioPatient.fromJson(model)))
          : <BioPatient>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> patients = <String, dynamic>{};
    patients["count"] = count;
    patients["next"] = next;
    patients["previous"] = previous;
    patients["results"] = List<Map<String, dynamic>>.from(results.map(
      (e) => e.toJson(),
    ));
    return patients;
  }
}
