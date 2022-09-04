import 'package:pss/models/bio_doctor.dart';

class DoctorsListResult {
  // Class modelling response form getDoctors request

  final int count;
  final String? next;
  final String? previous;
  final List<BioDoctor> results;

  DoctorsListResult({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory DoctorsListResult.fromJson(Map<String, dynamic> json) {
    return DoctorsListResult(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
      results: json["results"] != null
          ? List<BioDoctor>.from(
              json["results"].map((model) => BioDoctor.fromJson(model)))
          : <BioDoctor>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> doctors = <String, dynamic>{};
    doctors["count"] = count;
    doctors["next"] = next;
    doctors["previous"] = previous;
    doctors["results"] = List<Map<String, dynamic>>.from(results.map(
      (e) => e.toJson(),
    ));
    return doctors;
  }
}
