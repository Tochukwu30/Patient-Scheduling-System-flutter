import 'package:flutter/material.dart';
import 'package:pss/models/bio_doctor.dart';
import 'package:pss/models/doctors_list.dart';
import 'package:pss/widgets/appdrawer.dart';
import 'package:pss/widgets/buttons.dart';
import 'package:pss/widgets/doctors_list.dart';

import '../service/pss_api.dart';
import '../service/pss_doctors_api.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({Key? key}) : super(key: key);

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final _filterFirstName = TextEditingController();
  final _filterLastName = TextEditingController();
  final _filterEmail = TextEditingController();
  final _filterSpeciality = TextEditingController();
  final _controller = ScrollController();
  late Future<bool> _future;

  List<BioDoctor> doctorList = [];
  String? next;
  // bool _error = false;

  Future<bool> fetchDoctors({
    String? firstName,
    String? lastName,
    String? email,
    String? speciality,
  }) async {
    ApiResponse result = await getDoctors(
      firstName: firstName,
      lastName: lastName,
      email: email,
      speciality: speciality,
    );
    if (result.hasData()) {
      final doctorsResult = result.Data as DoctorsListResult;
      setState(() {
        doctorList = doctorsResult.results;
        next = doctorsResult.next;
        // _error = false;
      });
      return true;
    }
    return false;
  }

  void getNext() async {
    ApiResponse result = await getNextDoctors(next: next!);
    if (result.hasData()) {
      final doctorsResult = result.Data as DoctorsListResult;
      setState(() {
        doctorList.addAll(doctorsResult.results);
        next = doctorsResult.next;
      });
    }
  }

  @override
  void dispose() {
    _filterFirstName.dispose();
    _filterLastName.dispose();
    _filterEmail.dispose();
    _filterSpeciality.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // fetchDoctors();
    super.initState();
    _future = fetchDoctors();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (next != null) {
          getNext();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        title: const Text("Doctors"),
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
                          height: 10.0,
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          children: <Widget>[
                            const Text("Speciality:"),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                controller: _filterSpeciality,
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
                              fetchDoctors(
                                firstName: _filterFirstName.text == ""
                                    ? null
                                    : _filterFirstName.text,
                                lastName: _filterLastName.text == ""
                                    ? null
                                    : _filterLastName.text,
                                email: _filterEmail.text == ""
                                    ? null
                                    : _filterEmail.text,
                                speciality: _filterSpeciality.text == ""
                                    ? null
                                    : _filterSpeciality.text,
                              );
                            });
                          },
                          text: "Apply",
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              FutureBuilder<bool>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        bool response = snapshot.data!;
                        if (response) {
                          return DoctorsListWidget(
                            doctors: doctorList,
                          );
                        } else {
                          return const Center(
                            child: Text("Nothing to display"),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
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
