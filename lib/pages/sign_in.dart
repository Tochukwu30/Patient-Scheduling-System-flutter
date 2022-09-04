import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pss/service/pss_api.dart';
import 'package:pss/widgets/buttons.dart';
import 'package:pss/widgets/password_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();

  void _signIn() async {
    ApiResponse response = await authenticateUser(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    if (response.hasData()) {
      // AccessToken token =
      //     AccessToken.fromJson(await SessionManager().get("token"));
      // if (!mounted) return;
      Navigator.of(context).pushNamed("/appointments");

      // switch (token.role) {
      //   case "Doctor":
      //     if (!mounted) return;
      //     Navigator.of(context).pushNamed("/patients");

      //     break;
      //   case "Patient":
      //     if (!mounted) return;

      //     Navigator.of(context).pushNamed("/doctors");
      //     break;
      //   default:
      //     const unknownRole = SnackBar(content: Text("Something went wrong!"));
      //     if (!mounted) return;
      //     ScaffoldMessenger.of(context).showSnackBar(unknownRole);
      // }

      _signInFormKey.currentState?.reset();
    } else {
      final snackBar = SnackBar(
        content: Text(
          (response.ApiError as ApiError).error ??
              "Unknown Error. Please try again",
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearSession() async {
    await SessionManager().destroy();
  }

  @override
  void initState() {
    super.initState();
    clearSession();
  }

  @override
  Widget build(BuildContext context) {
    var vh = MediaQuery.of(context).size.height;
    var vw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      // backgroundColor: const Color(0xFF1F1A30),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  // height: vh > 500 ? 500 : vh,
                  width: vw > 500 ? 500 : vw,
                  padding: EdgeInsets.symmetric(
                    vertical: 0.2 * vh,
                    horizontal: 10.0,
                  ),
                  child: Form(
                    key: _signInFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Center(
                          child: Text(
                            "Sign In",
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                            // hintText: "Username",
                            label: Text("Email"),
                            // border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: vh * 0.02,
                        ),
                        PasswordField(
                          controller: _passwordController,
                          labelText: "Password",
                        ),
                        SizedBox(
                          height: 0.04 * vh,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (newValue) {
                                setState(() {
                                  _rememberMe = newValue!;
                                });
                              },
                            ),
                            const Text(
                              "Remember me",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.02 * vh,
                        ),
                        FormButton(
                          onPressed: () {
                            if (_signInFormKey.currentState!.validate()) {
                              _signIn();
                            }
                          },
                          text: "Sign in",
                        ),
                        SizedBox(
                          height: vh * 0.02,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot password?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: vh * 0.12,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Don't have an account?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("/signup");
                              },
                              child: const Text(
                                "Sign up",
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
