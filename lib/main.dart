import 'package:flutter/material.dart';
import 'package:pss/pages/appointments.dart';
import 'package:pss/pages/biodata.dart';
import 'package:pss/pages/chatslist.dart';
import 'package:pss/pages/doctors.dart';
import 'package:pss/pages/patients.dart';
import 'package:pss/pages/sign_in.dart';
import 'package:pss/pages/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
        ).copyWith(),
      ),
      // home: const SignIn(),
      initialRoute: "/signin",
      routes: {
        "/signin": (context) => const SignIn(),
        "/signup": (context) => const SignUp(),
        "/bio": (context) => const BioData(),
        "/appointments": (context) => const Appointments(),
        "/patients": (context) => const PatientsPage(),
        "/doctors": (context) => const DoctorsPage(),
        "/chats": (context) => const ChatList(),
      },
    );
  }
}
