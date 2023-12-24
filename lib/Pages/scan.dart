// ignore_for_file: file_names, unnecessary_import, undefined_shown_name

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:gp_project/Pages/login.dart';
import 'package:gp_project/shared/snackbar.dart';
import 'package:path/path.dart' show basename ; //dirname;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:path_provider/path_provider.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});
  @override
  State<Scan> createState() => _HomeState();
}

class _HomeState extends State<Scan> {
  //varible to Store the img path
  File? imgPath;
  String? imgName;
  String imageLabel = " ";
//final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
  // to make the floating action button visable after choosing the img
  bool inVsiable = true;

  // to make the Text above the camera icon invisable after choosing the img
  bool textVisable = false;

  // varible to hide the text and camera after choosing the img
  bool choosedimg = false;

  // uploadImage2Screen Function to make the img on the screen
  uploadImage2Screen(ImageSource theType) async {
    final pickedImg = await ImagePicker().pickImage(source: theType);
    try {
      if (pickedImg != null)  {
        
        setState((){
          imgPath = File(pickedImg.path);
          inVsiable = false;
          textVisable = true;
          getImageLabel(pickedImg);
        });
        imgName = basename(pickedImg.path);
      } else {}
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, "Error happened duo to : ..$e");
    }
  }

  // function to Choose camera or gallaery
  chooseCameraOrGallary() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 170,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await uploadImage2Screen(ImageSource.camera);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 30,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        "From Camera",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                GestureDetector(
                  onTap: () async {
                    await uploadImage2Screen(ImageSource.gallery);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.photo_outlined,
                        size: 30,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        "From Gallery",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // function to get the label of the photo
  void getImageLabel(XFile image) async{
    final inputImage = InputImage.fromFilePath(image.path);
        // varible or the custom model  
    // final modelPath = await getModelPath('assets/ml/model_unquant.tflite');
    // final options = LocalLabelerOptions(
    //   confidenceThreshold: 0.5,
    //   modelPath: modelPath,
    // );
    ImageLabeler imageLabeler = ImageLabeler(options: ImageLabelerOptions());
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    StringBuffer sb = StringBuffer();

    for (ImageLabel imgLabel in labels){
      String lblText = imgLabel.label;
      double confidence = imgLabel.confidence;
      sb.write(lblText);
      sb.write(" : ");
      sb.write((confidence * 100).toStringAsFixed(2));
      sb.write("%\n");
    }
    imageLabeler.close();
    imageLabel = sb.toString();
    setState(() {});
  }

  //function to get our custom model path
//   Future<String> getModelPath(String asset) async {
//   final path = '${(await getApplicationSupportDirectory()).path}/$asset';
//   await Directory(dirname(path)).create(recursive: true);
//   final file = File(path);
//   if (!await file.exists()) {
//     final byteData = await rootBundle.load(asset);
//     await file.writeAsBytes(byteData.buffer
//             .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//   }
//   return file.path;
// }
 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: inVsiable
            ? null
            : FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                 chooseCameraOrGallary();
                },
              ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            // the Sign out Icon in the app bar
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  showSnackBar(context, "you Signed out");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  size: 35,
                  color: Colors.red,
                )),
          ],
        ),
        body: Container(
          //Background Image
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage(
                    "assets/images/SSS.jpg",
                  ),
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8),
                    BlendMode.modulate,
                  ),
                  fit: BoxFit.cover)),
          height: double.infinity,
          width: double.infinity,
          child: choosedimg
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.file(imgPath!,width: double.infinity,height: 400,),
                        const SizedBox(
                          height: 20,
                        ),
                        Text( imageLabel ,
                        style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    // the text above the camera icon
                    Text(
                      textVisable ? " " : "Click on the Camera Icon to Scan ",
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 350,
                    ),

                    // the Camera Icon
                    GestureDetector(
                        onTap: () async {
                          await chooseCameraOrGallary();
                          setState(() {
                            choosedimg = true;
                          });
                        },
                        child: Image.asset(
                          "assets/icons/Camera.png",
                          height: 200,
                          width: 400,
                        )),
                  ],
                ),
        ),
      ),
    );
  }
}
