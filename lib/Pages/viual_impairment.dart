import 'package:flutter/material.dart';
import 'package:gp_project/Pages/login.dart';
import 'package:gp_project/Pages/signup.dart';


class ViualImpairment extends StatelessWidget {
  const ViualImpairment({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.369),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Visual Impairment",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.normal,
                            height: 1,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 50, 95, 116)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 79, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27))),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: "myfont"),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Signup()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 50, 95, 116)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27))),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: "myfont"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        )
      )
    );
  }
}