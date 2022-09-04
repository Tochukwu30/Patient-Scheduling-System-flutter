import 'package:flutter/material.dart';
import 'package:pss/models/bio_patient.dart';
import 'package:pss/pages/schedule_appointment.dart';

import '../models/user.dart';
import '../pages/chat.dart';

class PatientsListWidget extends StatefulWidget {
  final List<BioPatient> patients;
  const PatientsListWidget({Key? key, required this.patients})
      : super(key: key);

  @override
  State<PatientsListWidget> createState() => _PatientsListWidgetState();
}

class _PatientsListWidgetState extends State<PatientsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.patients.length,
          itemBuilder: (BuildContext context, int index) {
            BioPatient patient = widget.patients[index];
            return InkWell(
              // Make Patients clickable
              onTap: () {
                showDialog(
                  // Shows the doctor's details
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // Widget displaying the Patients details
                      contentPadding: const EdgeInsets.all(20),
                      scrollable: true,
                      actions: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  user: User(
                                    id: patient.id,
                                    email: patient.email!,
                                    firstName: patient.firstName!,
                                    lastName: patient.lastName!,
                                    role: "Patient",
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.message_outlined),
                        ),
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor,
                            )),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (contest) => ScheduleAppointment(
                                    patient: patient,
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Schedule \n Appointment",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ))
                      ],
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actionsPadding: const EdgeInsets.all(10.0),
                      content: Stack(
                        children: <Widget>[
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: InkResponse(
                              radius: 20.0,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  size: 10.0,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.person,
                                  size: 70.0,
                                ),
                                Text(
                                  "${patient.firstName} ${patient.lastName}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: Ink(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.black26,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 10.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${patient.firstName} ${patient.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    ]);
  }
}
