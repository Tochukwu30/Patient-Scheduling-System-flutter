import 'package:flutter/material.dart';
import 'package:pss/models/bio_patient.dart';
import 'package:pss/service/pss_api.dart';
import 'package:pss/widgets/buttons.dart';

class BioFormPatient extends StatefulWidget {
  const BioFormPatient({Key? key}) : super(key: key);

  @override
  State<BioFormPatient> createState() => __BioFormPatientState();
}

class __BioFormPatientState extends State<BioFormPatient> {
  late Future<ApiResponse> _future;
  final bioPatientKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final homeAddressController = TextEditingController();

  void submit() async {
    ApiResponse response = await updateBio(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      homeAddress: homeAddressController.text,
    );
    if (response.statusCode == 200) {
      const bioUpdateSnackBar = SnackBar(
        content: Text("Profile updated"),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(bioUpdateSnackBar);
      Navigator.pushNamed(context, "/appointments");
    } else {
      const bioUpdateSnackBar = SnackBar(
        content: Text("Could not update biodata"),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(bioUpdateSnackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    _future = getBio();
    _future.then((value) {
      if (value.hasData()) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final BioPatient patient = value.Data as BioPatient;
          setState(() {
            firstNameController.text = patient.firstName ?? "";
            lastNameController.text = patient.lastName ?? "";
            phoneNumberController.text = patient.phoneNumber ?? "";
            emailController.text = patient.email ?? "";
            homeAddressController.text = patient.homeAddress ?? "";
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var vh = MediaQuery.of(context).size.height;
    // var vw = MediaQuery.of(context).size.width;
    return FutureBuilder<ApiResponse>(
        future: _future,
        builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.hasData()) {
              return Form(
                key: bioPatientKey,
                // autovalidateMode: AutovalidateMode.,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: vh * 0.02,
                    ),
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                        ),
                        label: Text("First Name"),
                        // border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: vh * 0.02,
                    ),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                        ),
                        label: Text("Last Name"),
                        // border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: vh * 0.02,
                    ),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                        ),
                        label: Text("Phone Number"),
                        // border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: vh * 0.02,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                        label: Text("Email"),
                        // border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: vh * 0.02,
                    ),
                    TextFormField(
                      controller: homeAddressController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.house_outlined,
                        ),
                        label: Text("Home Address"),
                        // border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: vh * 0.02,
                    ),
                    FormButton(
                      onPressed: () {
                        if (bioPatientKey.currentState!.validate()) {
                          submit();
                        }
                      },
                      text: "Submit",
                    ),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return const Text("Couldn't fetch data. Please retry.");
          } else {
            return const CircularProgressIndicator();
          }
          return const Text("Someting went wrong");
        });
  }
}
