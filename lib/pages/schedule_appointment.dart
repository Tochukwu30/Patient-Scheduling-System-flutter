import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pss/models/bio_doctor.dart';
import 'package:pss/models/bio_patient.dart';
import 'package:pss/service/pss_api.dart';
import 'package:pss/service/pss_appointments_api.dart';
import 'package:pss/widgets/appdrawer.dart';

class ScheduleAppointment extends StatefulWidget {
  final BioDoctor? doctor;
  final BioPatient? patient;
  const ScheduleAppointment({
    Key? key,
    this.doctor,
    this.patient,
  }) : super(key: key);

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  late Map<String, dynamic> token;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void getToken() async {
    Map<String, dynamic> token_ = await SessionManager().get("token");
    setState(() {
      token = token_;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = selectedTime.format(context);
      });
    }
  }

  void schedule() async {
    final date = DateTime.parse(_dateController.text);

    final time = TimeOfDay(
        hour: int.parse(_timeController.text.split(":")[0]),
        minute: int.parse(
          _timeController.text.split(":")[1],
        ));
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    ApiResponse response = await createAppointments(
      dateTime: dateTime,
      description: _descriptionController.text == ""
          ? null
          : _descriptionController.text,
      doctor: widget.doctor?.id ?? token["id"],
      patient: widget.patient?.id ?? token["id"],
    );
    if (!mounted) return;
    if (response.statusCode == 201) {
      const snackBar = SnackBar(
        content: Text("Appointment created"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    } else {
      const snackBar = SnackBar(
        content: Text("Couldn't create appointment"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    getToken();
    _dateController.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
    _timeController.text = DateFormat("hh:mm").format(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        title: const Text("Schedule Appointment"),
      ),
      endDrawer: const PssDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.doctor != null
                  ? Container(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${widget.doctor!.firstName} ${widget.doctor!.lastName}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const Text("(Doctor)"),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              widget.patient != null
                  ? Container(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${widget.patient!.firstName} ${widget.patient!.lastName}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const Text("(Patient)"),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),

              // Form to schedule appointment
              Form(
                child: Column(
                  children: <Widget>[
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: <Widget>[
                        // Date Widget
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: <Widget>[
                            const Text("Date: "),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                style: const TextStyle(),
                                textAlign: TextAlign.center,
                                // enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _dateController,
                                // onSaved: (String val) {
                                //   _setDate = val;
                                // },
                                decoration: InputDecoration(
                                  // disabledBorder:
                                  //     UnderlineInputBorder(borderSide: BorderSide.none),
                                  // contentPadding: EdgeInsets.only(top: 0.0),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: const Icon(
                                        Icons.calendar_today_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Time widget
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: <Widget>[
                            const Text("Time: "),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                                // enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _timeController,
                                // onSaved: (String val) {
                                //   _setDate = val;
                                // },
                                decoration: InputDecoration(
                                  // disabledBorder:
                                  //     UnderlineInputBorder(borderSide: BorderSide.none),
                                  // contentPadding: EdgeInsets.only(top: 0.0),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      _selectTime(context);
                                    },
                                    child:
                                        const Icon(Icons.access_time_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 5,
                      maxLines: 10,
                      decoration: const InputDecoration(
                          label: Text("Description"),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        schedule();
                      },
                      child: const Text("Schedule"),
                    )
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
