import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pss/widgets/appdrawer.dart';
import 'package:pss/widgets/bio_form_doctor.dart';
import 'package:pss/widgets/bio_form_patient.dart';

class BioData extends StatefulWidget {
  const BioData({Key? key}) : super(key: key);

  @override
  State<BioData> createState() => _BioDataState();
}

class _BioDataState extends State<BioData> {
  String role = "";

  Widget getForm() {
    switch (role) {
      case "Doctor":
        return const BioFormDoctor();
      case "Patient":
        return const BioFormPatient();
      default:
        return const Text("Something went wrong");
    }
  }

  Future<String> getRole() async {
    role = (await SessionManager().get("token"))["role"];
    return role;
  }

  @override
  Widget build(BuildContext context) {
    var vh = MediaQuery.of(context).size.height;
    var vw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        title: const Text("Profile"),
      ),
      endDrawer: const PssDrawer(),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 0,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  // height: vh > 500 ? 500 : vh,
                  width: vw > 500 ? 500 : vw,
                  padding: EdgeInsets.symmetric(
                    vertical: 0.2 * vh,
                    horizontal: 10.0,
                  ),
                  child: FutureBuilder<String>(
                      future: getRole(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return getForm();
                        } else if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
