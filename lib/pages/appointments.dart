import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pss/models/appointment.dart';
import 'package:pss/service/pss_api.dart';
import 'package:pss/service/pss_appointments_api.dart';
import 'package:pss/widgets/appointment.dart';

import '../widgets/appdrawer.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  final _controller = ScrollController();
  List<Appointment> appointmentsList = [];
  late String? next;
  late Map<String, dynamic> token;
  late Future<bool> _future;

  Future<bool> fetchAppointments() async {
    ApiResponse result = await getAppointments();
    if (result.hasData()) {
      final appointmentResult = result.Data as AppointmentsListResult;
      setState(() {
        appointmentsList.addAll(appointmentResult.results);
        next = appointmentResult.next;
      });
      return true;
    }
    return false;
  }

  void getNext() async {
    ApiResponse result = await getNextAppointments(next: next!);
    if (result.hasData()) {
      final appointmentResult = result.Data as AppointmentsListResult;
      setState(() {
        appointmentsList.addAll(appointmentResult.results);
        next = appointmentResult.next;
      });
    }
  }

  void getToken() async {
    Map<String, dynamic> token_ = await SessionManager().get("token");
    setState(() {
      token = token_;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    fetchAppointments();
    getToken();
    _future = fetchAppointments();
    super.initState();
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
        title: const Text("Appointments"),
      ),
      endDrawer: const PssDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<bool>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return ListView.builder(
                        controller: _controller,
                        itemCount: appointmentsList.length + 1,
                        itemBuilder: (context, index) {
                          if (appointmentsList.isEmpty) {
                            return const ListTile(
                              title: Text("You have no appointment"),
                            );
                          } else if (index < appointmentsList.length) {
                            final appointment = appointmentsList[index];

                            return InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  showDialog(
                                    // Display dialog box for appointment details
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        // Create box for appointment details
                                        title: const Text("Appointment Card"),
                                        scrollable: true,
                                        contentPadding:
                                            const EdgeInsets.all(20.0),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceAround,
                                        actionsPadding:
                                            const EdgeInsets.all(20.0),
                                        actions: [
                                          // Conditionally display buttons depending on user role
                                          // and appointment status
                                          token["id"] != appointment.createdBy
                                              ? appointment.status ==
                                                      "scheduled"
                                                  ? TextButton(
                                                      onPressed: () async {
                                                        ApiResponse response =
                                                            await updateAppointment(
                                                                id: appointment
                                                                    .id,
                                                                status:
                                                                    "confirmed");
                                                        if (!mounted) return;
                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          const snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                "Appointment confirmed"),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  "/appointments");
                                                        } else {
                                                          final snackBar =
                                                              SnackBar(
                                                            content: Text((response
                                                                            .ApiError
                                                                        as ApiError)
                                                                    .error ??
                                                                "Unknown error"),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                          padding:
                                                              MaterialStateProperty.all(
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .green),
                                                          splashFactory: InkSplash
                                                              .splashFactory),
                                                      child: const Text(
                                                        "Confirm\nAppointment",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                              : Container(),
                                          appointment.status == "scheduled"
                                              ? TextButton(
                                                  onPressed: () async {
                                                    ApiResponse response =
                                                        await updateAppointment(
                                                            id: appointment.id,
                                                            status:
                                                                "cancelled");
                                                    if (!mounted) return;
                                                    if (response.statusCode ==
                                                        200) {
                                                      const snackBar = SnackBar(
                                                        content: Text(
                                                            "Appointment cancelled"),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              "/appointments");
                                                    } else {
                                                      final snackBar = SnackBar(
                                                        content: Text((response
                                                                        .ApiError
                                                                    as ApiError)
                                                                .error ??
                                                            "Unknown error"),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                                const EdgeInsets
                                                                    .all(10.0)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red),
                                                    splashFactory:
                                                        InkSplash.splashFactory,
                                                  ),
                                                  child: const Text(
                                                    "Cancel\nAppointment",
                                                    // ignore: unnecessary_const
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                        content: Column(
                                          // Contains the appointment details
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Wrap(
                                              spacing: 5.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                const Text("Doctor: "),
                                                Text(
                                                  "${appointment.doctor.firstName} ${appointment.doctor.lastName}",
                                                )
                                              ],
                                            ),
                                            Wrap(
                                              spacing: 5.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                const Text("Patient: "),
                                                Text(
                                                  "${appointment.patient.firstName} ${appointment.patient.lastName}",
                                                )
                                              ],
                                            ),
                                            Wrap(
                                              spacing: 5.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                const Text("Scheduled for: "),
                                                Text(
                                                  DateFormat("dd-MM-yyyy kk:mm")
                                                      .format(
                                                          appointment.dateTime),
                                                )
                                              ],
                                            ),
                                            Wrap(
                                              spacing: 5.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                const Text("Description: "),
                                                Text(
                                                  appointment.description ??
                                                      "No description",
                                                )
                                              ],
                                            ),
                                            Wrap(
                                              spacing: 5.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                const Text("Status: "),
                                                Text(
                                                  appointment.status ==
                                                          "scheduled"
                                                      ? "awaiting confirmation"
                                                      : appointment.status,
                                                )
                                              ],
                                            ),
                                            Wrap(
                                              spacing: 5.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                const Text("Scheduled on: "),
                                                Text(
                                                  DateFormat("dd-MM-yyyy kk:mm")
                                                      .format(appointment
                                                          .scheduledOn
                                                          .toLocal()),
                                                )
                                              ],
                                            ),
                                            appointment.status == "confirmed"
                                                ? Wrap(
                                                    spacing: 5.0,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      const Text(
                                                          "Confirmed on: "),
                                                      Text(
                                                        DateFormat(
                                                                "dd-MM-yyyy kk:mm")
                                                            .format(appointment
                                                                .confirmedOn!
                                                                .toLocal()),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                            appointment.status == "cancelled"
                                                ? Wrap(
                                                    spacing: 5.0,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      const Text(
                                                          "Cancelled on: "),
                                                      Text(
                                                        DateFormat(
                                                                "dd-MM-yyyy kk:mm")
                                                            .format(appointment
                                                                .cancelledOn!
                                                                .toLocal()),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child:
                                    AppointmentTile(appointment: appointment));
                          } else {
                            return Container();
                          }
                        });
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
      ),
    );
  }
}
