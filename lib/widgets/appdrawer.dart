import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class PssDrawer extends StatefulWidget {
  const PssDrawer({Key? key}) : super(key: key);

  @override
  State<PssDrawer> createState() => _PssDrawerState();
}

class _PssDrawerState extends State<PssDrawer> {
  final Map<String, String> notRole = {
    "Patient": "Doctors",
    "Doctor": "Patients",
  };
  String role = "";
  Future<String> getRole() async {
    String role_ = (await SessionManager().get("token"))["role"];
    setState(() {
      role = role_;
    });
    return role;
  }

  @override
  void initState() {
    getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Text(
              "Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Theme.of(context).primaryColor,
              ),
            )),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/bio");
            },
            title: const Text("Profile"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushNamed("/${notRole[role]!.toLowerCase()}");
            },
            title: Text("${notRole[role]}"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/appointments");
            },
            title: const Text("Appointments"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/chats");
            },
            title: const Text("Chats"),
          ),
          ListTile(
            onTap: () async {
              await SessionManager().destroy();
              if (!mounted) return;
              Navigator.of(context).popUntil(
                ModalRoute.withName("/signin"),
              );
            },
            title: const Text("Sign Out"),
          )
        ],
      ),
    );
  }
}
