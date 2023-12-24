import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/Pages/login.dart';
import 'package:gp_project/shared/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // controllers to take the text writing in the text field
  final emailController = TextEditingController();

  // varible to do the loading shape after clicking on the button
  bool isLoading = false;

  // varible needed to jsut the form () Widget
  final _formKey = GlobalKey<FormState>();

  // the Password reset Function
  resetPassword() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    }
  }

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // The back arrow Icon to go Back to the last page
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        // the title in the app bar
        title: const Text("Reset Password"),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 50, 95, 116),
      ),
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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    // the text above the textfield
                    const Text("Enter your email to rest your password.",
                        style:
                            TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 130,
                    ),
                    // the Column() of Email Textfield and reset password Button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 33,
                        ),
                        // Email textfield
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
                              return value != null &&
                                      !EmailValidator.validate(value)
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
                        // the reset password Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              resetPassword();
                            } else {
                              showSnackBar(context, "ERROR");
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 50, 95, 116)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.black),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
