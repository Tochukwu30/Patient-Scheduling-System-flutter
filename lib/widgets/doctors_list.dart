import 'package:flutter/material.dart';
import 'package:pss/models/bio_doctor.dart';
import 'package:pss/models/user.dart';
import 'package:pss/pages/chat.dart';
import 'package:pss/pages/schedule_appointment.dart';

class DoctorsListWidget extends StatefulWidget {
  final List<BioDoctor> doctors;
  const DoctorsListWidget({Key? key, required this.doctors}) : super(key: key);

  @override
  State<DoctorsListWidget> createState() => _DoctorsListWidgetState();
}

class _DoctorsListWidgetState extends State<DoctorsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.doctors.length,
          itemBuilder: (BuildContext context, int index) {
            BioDoctor doctor = widget.doctors[index];
            return InkWell(
              // Make doctors clickable
              onTap: () {
                showDialog(
                  // Shows the doctor's details
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // Widget displaying the doctors details
                      contentPadding: const EdgeInsets.all(10),
                      elevation: 0.0,
                      scrollable: true,
                      actions: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  user: User(
                                    id: doctor.id,
                                    email: doctor.email!,
                                    firstName: doctor.firstName!,
                                    lastName: doctor.lastName!,
                                    role: "Doctor",
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
                                    doctor: doctor,
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
                                  "${doctor.firstName} ${doctor.lastName}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(doctor.speciality ?? "Unknown speciality"),
                                Text(doctor.officeAddress ?? "Unknown address"),
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
                        "${doctor.firstName} ${doctor.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(doctor.speciality ?? "Unknown speciality"),
                      Text(doctor.officeAddress ?? "Unknown address"),
                    ],
                  ),
                ),
              ),
            );
          }),
    ]);
  }
}
