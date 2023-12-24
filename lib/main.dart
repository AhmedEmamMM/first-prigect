import 'package:flutter/material.dart';
import 'package:gp_project/Pages/Provider/google_signin.dart';
import 'package:gp_project/Pages/verify_email.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp_project/Pages/viual_impairment.dart';
import 'package:gp_project/firebase_options.dart';
import 'package:gp_project/shared/snackbar.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) {
     return GoogleSignInProvider();
    }),
    ],
    child: MaterialApp(
    title: "myApp",
    debugShowCheckedModeBanner: false,
    home: StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(
    color: Colors.white,
      ));
    } else if (snapshot.hasError) {
    return showSnackBar(context, "Something went wrong");
    } else if (snapshot.hasData) {
    return const VerifyEmailPage(); // home() OR verify email
    } else {
    return const ViualImpairment();
    }
    },
    )),
    );
  }
}