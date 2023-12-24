import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/Pages/forgot_password.dart';
import 'package:gp_project/Pages/Provider/google_signin.dart';
import 'package:gp_project/Pages/scan.dart';
import 'package:gp_project/Pages/signup.dart';
import 'package:gp_project/shared/snackbar.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //varible to show and hide the password
  bool visablePass = true;
  bool isVisable = false;

  // controllers to take the text writing in the text field
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // varible to do the loading shape after clicking on the button
  bool isLoading = false;

  // the sing-in function
  signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (!context.mounted) return;
      showSnackBar(context, "Done.......");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Scan()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      } else {
        showSnackBar(context, "ERROR :  ${e.code}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  //password validation varibles used in onPasswordChanged() function
  bool isPassword8Char = false;
  bool isPasswordHas1Number = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;

  // the Validation on password text field
  onPasswordChanged(String password) {
    isPassword8Char = false;
    isPasswordHas1Number = false;
    hasUppercase = false;
    hasLowercase = false;
    hasSpecialCharacters = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }

      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1Number = true;
      }

      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }

      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }

      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // varible needed to jsut the form () Widget
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        body: Container(
      // Background Image
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage(
                "assets/images/mathieu-turle-uJm-hfuCHm4-unsplash.jpg",
              ),
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8),
                BlendMode.modulate,
              ),
              fit: BoxFit.cover)),
      height: double.infinity,
      width: double.infinity,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(33.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 50,
              ),
              // Email TextFormField
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                    ),
                  ],
                ),
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  validator: (value) {
                    return value != null && !EmailValidator.validate(value)
                        ? "Enter a valid email"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  controller: emailController,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.mail,
                        color: Colors.blue[800],
                      ),
                      hintText: "Email",
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              // Password TextFormField
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                    ),
                  ],
                ),
                width: 350,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  onChanged: (password) {
                    onPasswordChanged(password);
                  },
                  validator: (value) {
                    return value!.length < 8
                        ? "Enter at least 8 characters"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: visablePass,
                  decoration: InputDecoration(
                      suffix: IconButton(
                        iconSize: 20,
                        padding: const EdgeInsets.only(top: 20),
                        onPressed: () {
                          setState(() {
                            visablePass = !visablePass;
                          });
                        },
                        icon: visablePass
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        color: Colors.blue[900],
                      ),
                      icon: Icon(
                        Icons.lock,
                        color: Colors.blue[800],
                        size: 19,
                      ),
                      hintText: "Password",
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              // Sign-in Button
              ElevatedButton(
                onPressed: () async {
                  await signIn();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 50, 95, 116)),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 106, vertical: 10)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27))),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
              ),
              const SizedBox(
                height: 30,
              ),
              //Forgot-your-Password Button
              TextButton(
                onPressed: () {
                  if (!mounted) return;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: const Text(
                  "Forgot your Password...?",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //Do not have an account Row()
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21),
                  ),
                  color: Color.fromRGBO(54, 67, 72, 60),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do not have an account?",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()),
                          );
                        },
                        child: const Text('sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ))),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Divider Or
              const SizedBox(
                width: 299,
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 1.9,
                      color: Colors.black,
                    )),
                    Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 1.9,
                      color: Colors.black,
                    )),
                  ],
                ),
              ),
              // the 3 Icons
              Container(
                margin: const EdgeInsets.symmetric(vertical: 27),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // apple icon
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          color: Color.fromRGBO(54, 67, 72, 99),
                        ),
                        child: Image.asset(
                          "assets/images/apple_pic.png",
                          height: 27,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    // Google icon
                    GestureDetector(
                      onTap: () {
                        googleSignInProvider.googlelogin();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          color: Color.fromRGBO(54, 67, 72, 99),
                        ),
                        child: Image.asset(
                          "assets/images/google_pic.png",
                          height: 27,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    // facebook icon
                    GestureDetector(
                      onTap: () async {
                        // await signInWithFacebook();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          color: Color.fromRGBO(54, 67, 72, 99),
                        ),
                        child: Image.asset(
                          "assets/images/facebook_pic.png",
                          height: 27,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      )),
    ));
  }
}
