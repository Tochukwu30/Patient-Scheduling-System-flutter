import 'package:flutter/material.dart';
import 'package:pss/pages/sign_in.dart';
import 'package:pss/service/pss_api.dart';
import 'package:pss/utils.dart';
import 'package:pss/widgets/buttons.dart';
import 'package:pss/widgets/password_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _signUpAs = "Patient";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();

  void _signUp() async {
    ApiResponse response = await registerUser(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _signUpAs);

    if (!mounted) return;
    if (response.hasData()) {
      const accountCreatedSnackBar =
          SnackBar(content: Text("Accout created. Please sign in."));
      ScaffoldMessenger.of(context).showSnackBar(accountCreatedSnackBar);
      Navigator.pushNamed(context, "/signin");
    } else {
      final snackBar = SnackBar(
        content: Text(
          (response.ApiError as ApiError).error ??
              "Unknown Error. Please try againn",
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
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
      ),
      // backgroundColor: const Color(0xFF1F1A30),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Center(
                // width: 0.8 * vw,

                // padding: EdgeInsets.symmetric(
                //   vertical: vh * 0.2,
                //   horizontal: vw * 0.2,
                // ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: 0.2 * vh,
                    horizontal: 10.0,
                  ),
                  // height: vh > 500 ? 500 : vh,
                  width: vw > 500 ? 500 : vw,
                  child: Form(
                    key: _signUpFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Center(
                          child: Text(
                            "Sign Up",
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                            // hintText: "Username",
                            label: Text("Email"),
                            // border: InputBorder.none,
                          ),
                          validator: validateEmail,
                        ),
                        SizedBox(
                          height: vh * 0.02,
                        ),
                        PasswordField(
                          controller: _passwordController,
                          labelText: "Password",
                        ),
                        SizedBox(
                          height: vh * 0.02,
                        ),
                        PasswordField(
                          controller: _confirmPasswordController,
                          labelText: "Confirm Password",
                          validator: (value) {
                            String? checkEmpty = validateEmpty(value);
                            if (checkEmpty != null) {
                              return checkEmpty;
                            }
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: vh * 0.02,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20.0,
                          children: <Widget>[
                            const Text(
                              "Sign up as:",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            DropdownButton<String>(
                                value: _signUpAs,
                                hint: const Text("Sign up as"),
                                items: <String>["Patient", "Doctor"]
                                    .map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _signUpAs = newValue!;
                                  });
                                })
                          ],
                        ),
                        SizedBox(
                          height: 0.04 * vh,
                        ),
                        FormButton(
                          onPressed: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              _signUp();
                            }
                          },
                          text: "Sign up",
                        ),
                        SizedBox(
                          height: vh * 0.12,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Already have an account?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const SignIn();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
