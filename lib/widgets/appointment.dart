import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pss/models/appointment.dart';

class AppointmentTile extends StatefulWidget {
  final Appointment appointment;
  const AppointmentTile({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  State<AppointmentTile> createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  String role = "";
  Map<String, Color> statusColor = {
    "scheduled": Colors.white,
    "confirmed": Colors.green,
    "cancelled": Colors.red,
  };
  void getRole() async {
    Map<String, dynamic> token = await SessionManager().get("token");
    setState(() {
      role = token["role"];
    });
  }

  @override
  void initState() {
    getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: statusColor[widget.appointment.status],
        border: const Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black26,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          Text(
            DateFormat("dd-MM-yyy kk:mm").format(
              widget.appointment.dateTime.toLocal(),
            ),
          ),
          role == "Patient"
              ? Text(
                  "${widget.appointment.doctor.firstName} ${widget.appointment.doctor.lastName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : Text(
                  "${widget.appointment.patient.firstName} ${widget.appointment.patient.lastName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
        ]),
      ),
    );
  }
}
