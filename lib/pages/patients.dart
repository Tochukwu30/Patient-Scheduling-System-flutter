import 'package:flutter/material.dart';
import 'package:pss/models/bio_patient.dart';
import 'package:pss/models/patients_list.dart';
import 'package:pss/service/pss_api.dart';
import 'package:pss/widgets/appdrawer.dart';
import 'package:pss/widgets/buttons.dart';
import 'package:pss/widgets/patients_list.dart';

import '../service/pss_patients_api.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key}) : super(key: key);

  @override
  State<PatientsPage> createState() => _PateientsPageState();
}

class _PateientsPageState extends State<PatientsPage> {
  final _filterFirstName = TextEditingController();
  final _filterLastName = TextEditingController();
  final _filterEmail = TextEditingController();
  final _controller = ScrollController();
  late Future<bool> _future;

  List<BioPatient> patientList = [];
  String? next;
  // bool _error = false;

  Future<bool> fetchPatients({
    String? firstName,
    String? lastName,
    String? email,
    String? speciality,
  }) async {
    ApiResponse result = await getPatients(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
    if (result.hasData()) {
      final patientsResult = result.Data as PatientsListResult;
      setState(() {
        patientList = patientsResult.results;
        next = patientsResult.next;
        // _error = false;
      });
      return true;
    } else {
      setState(() {
        // _error = true;
      });
    }
    return false;
  }

  void getNext() async {
    ApiResponse result = await getNextPatients(next: next!);
    if (result.hasData()) {
      final patientsResult = result.Data as PatientsListResult;
      setState(() {
        patientList.addAll(patientsResult.results);
        next = patientsResult.next;
      });
    }
  }

  @override
  void dispose() {
    _filterFirstName.dispose();
    _filterLastName.dispose();
    _filterEmail.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // fetchDoctors();
    super.initState();
    _future = fetchPatients();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (next != null) {
          getNext();
        }
      }
    });
  }

  // Widget patientsList =

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        title: const Text("Patients"),
      ),
      endDrawer: const PssDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              ExpansionTile(
                title: const Text("Filters"),
                collapsedBackgroundColor: Colors.black12,
                children: <Widget>[
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 20,
                            children: <Widget>[
                              const Text("First name:"),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _filterFirstName,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 20,
                            children: <Widget>[
                              const Text("Last name:"),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _filterLastName,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 20,
                            children: <Widget>[
                              const Text("Email:"),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _filterEmail,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          FormButton(
                            onPressed: () {
                              setState(() {
                                fetchPatients(
                                  firstName: _filterFirstName.text == ""
                                      ? null
                                      : _filterFirstName.text,
                                  lastName: _filterLastName.text == ""
                                      ? null
                                      : _filterLastName.text,
                                  email: _filterEmail.text == ""
                                      ? null
                                      : _filterEmail.text,
                                );
                              });
                            },
                            text: "Apply",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder<bool>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        bool response = snapshot.data!;
                        if (response) {
                          return PatientsListWidget(
                            patients: patientList,
                          );
                        } else {
                          return const Center(
                            child: Text("Nothing to display"),
                          );
                        }
                      } else {
                        return const Text("Something went wrong");
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
