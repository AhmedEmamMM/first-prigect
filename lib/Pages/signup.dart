import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/Pages/login.dart';
import 'package:gp_project/Widgets/custom_text_field.dart';
import 'package:gp_project/shared/snackbar.dart';
import 'package:email_validator/email_validator.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // controllers to take the text writing in the text field
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // varible to do the loading shape after clicking on the button
  bool isLoading = false;

  //varible to show and hide the password
  bool visablePass = true;

  // the Sign-up function
  register() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (!context.mounted) return;
        showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        if (!context.mounted) return;
        showSnackBar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString());
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
    passController.dispose();
    fullnameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // varible needed to jsut the form () Widget
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // Background Image
        body: Container(
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
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.369),
                  ),
                  child: Column(
                    children: [
                      // The Sign-up Text
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            SizedBox(
                              height: 35,
                            ),
                            Text("Sign up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFE),
                                    fontFamily: "myfont")),
                            SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                  hint: "Full Name",
                                  icon: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  controllerr: fullnameController),
                              const SizedBox(
                                height: 13,
                              ),
                              // Stress Address textfield
                              CustomTextField(
                                hint: "Stress Address",
                                icon: const Icon(
                                  Icons.location_city,
                                  color: Colors.blue,
                                ),
                                controllerr: addressController,
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              // Phone Number textfield
                              CustomTextField(
                                hint: "Phone Number",
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                controllerr: phoneController,
                              ),
                              const SizedBox(
                                height: 13,
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
                                width: 320,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: TextFormField(
                                  validator: (value) {
                                    return value != null &&
                                            !EmailValidator.validate(value)
                                        ? "Enter a valid email"
                                        : null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.mail,
                                        color: Colors.blue,
                                      ),
                                      hintText: "Email",
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              // Password textfield
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
                                width: 320,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: TextFormField(
                                  onChanged: (password) {
                                    onPasswordChanged(password);
                                  },
                                  validator: (value) {
                                    return value!.length < 8
                                        ? "Enter at least 8 characters"
                                        : null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.text,
                                  controller: passController,
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
                                      icon: const Icon(
                                        Icons.lock,
                                        color: Colors.blue,
                                        size: 19,
                                      ),
                                      hintText: "Password",
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              // the all 5 valitions needs and the Already have an account Row()
                              Container(
                                width: 293,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(21),
                                    topRight: Radius.circular(21),
                                    bottomLeft: Radius.circular(21),
                                    bottomRight: Radius.circular(21),
                                  ),
                                  color: Color.fromRGBO(54, 67, 72, 60),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isPassword8Char
                                              ? Colors.green
                                              : Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 189, 189, 189)),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      const Text("At least 8 characters",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isPasswordHas1Number
                                              ? Colors.green
                                              : Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 189, 189, 189)),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      const Text("At least 1 number",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: hasUppercase
                                              ? Colors.green
                                              : Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 189, 189, 189)),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      const Text("Has Uppercase",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: hasLowercase
                                              ? Colors.green
                                              : Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 189, 189, 189)),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      const Text("Has  Lowercase",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: hasSpecialCharacters
                                              ? Colors.green
                                              : Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 189, 189, 189)),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      const Text("Has  Special Characters ",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text("Already have an account? ",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()),
                                            );
                                          },
                                          child: const Text(" Sign in",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19,
                                                  color: Colors.black)))
                                    ],
                                  ),
                                ]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Register Button
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await register();
                                    if (!context.mounted) return;
                                    await showSnackBar(context, "Done...");
                                    if (!mounted) return;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()),
                                    );
                                  } else {
                                    showSnackBar(context,
                                        "Error... , Please Check your Info");
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 50, 95, 116)),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 106, vertical: 10)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(27))),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Register",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
