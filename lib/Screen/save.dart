import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:wk5/Screen/search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wk5/Screen/studentmodel.dart';
import 'package:wk5/database/databasesqflite.dart';

class FrtPage extends StatefulWidget {
  const FrtPage({super.key});

  @override
  State<FrtPage> createState() => FrtPageState();
}

final formkey = GlobalKey<FormState>();
final idEditingcontroller = TextEditingController();
final nameEditingcontroller = TextEditingController();
final rollNumberEditingcontroller = TextEditingController();
final departmentEditingcontroller = TextEditingController();
final phoneEditingEditingcontroller = TextEditingController();

File? selectedImage;

class FrtPageState extends State<FrtPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text(" Student Information")),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: <Color>[Colors.purple, Colors.blue])),
            ),
            actions: [
              IconButton(
                color: Colors.amberAccent,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ));
                },
                icon: const Icon(
                  Icons.person_search,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Form(
                  key: formkey,
                  child: Column(children: [
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: () async {
                        File? pickedimage =
                            await selectimageFromGallery(context);
                        setState(() {
                          selectedImage = pickedimage;
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : null,
                        radius: 60,
                        child: IconButton(
                          onPressed: () {},
                          icon: selectedImage == null
                              ? const Icon(Icons.camera_alt)
                              : const Icon(null),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    txtformfld(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Student ID";
                          } else {
                            return null;
                          }
                        },
                        hnt: "Student id",
                        icn: const Icon(Icons.person),
                        controllerr: idEditingcontroller,
                        keybrd: TextInputType.name),
                    const SizedBox(height: 20),
                    txtformfld(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter The Name";
                          } else {
                            return null;
                          }
                        },
                        hnt: "Student Name",
                        icn: const Icon(Icons.person),
                        controllerr: nameEditingcontroller,
                        keybrd: TextInputType.text),
                    const SizedBox(height: 20),
                    txtformfld(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Roll  Number";
                        } else {
                          return null;
                        }
                      },
                      controllerr: rollNumberEditingcontroller,
                      hnt: "Roll Number",
                      icn: const Icon(Icons.numbers),
                      keybrd: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    txtformfld(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Department";
                          } else {
                            return null;
                          }
                        },
                        hnt: "Department",
                        icn: const Icon(Icons.school),
                        controllerr: departmentEditingcontroller,
                        keybrd: TextInputType.text),
                    const SizedBox(height: 20),
                    txtformfld(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Phone Number";
                        } else if (value.length < 10 || value.length > 10) {
                          return "Enter Valid Number";
                        }
                        return null;
                      },
                      controllerr: phoneEditingEditingcontroller,
                      hnt: "Phone Number",
                      icn: const Icon(Icons.phone),
                      keybrd: TextInputType.phone,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                        height: 40,
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                if (selectedImage != null) {
                                  final student = StudentModel(
                                      id: int.parse(idEditingcontroller.text),
                                      name: nameEditingcontroller.text,
                                      roll: int.parse(
                                          rollNumberEditingcontroller.text),
                                      department:
                                          departmentEditingcontroller.text,
                                      imageurl: selectedImage!.path,
                                      number:
                                          phoneEditingEditingcontroller.text);
                                  await addStudentToDB(student, context);
                                } else {
                                  snakbarBarFunction(
                                      "Please Select Students Image",
                                      context,
                                      Colors.red);
                                }
                              }
                            },
                            child: Text("SAVE"))),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        height: 40,
                        width: 300,
                        child: OutlinedButton(
                          onPressed: () {
                            idEditingcontroller.clear();
                            nameEditingcontroller.clear();
                            rollNumberEditingcontroller.clear();
                            departmentEditingcontroller.clear();
                            phoneEditingEditingcontroller.clear();
                            setState(() {
                              selectedImage = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              surfaceTintColor: Colors.deepOrange),
                          child: const Text(
                            "CLEAR",
                          ),
                        ))
                  ]),
                ),
              ),
            ),
          )),
    );
  }
}

class txtformfld extends StatelessWidget {
  const txtformfld({
    super.key,
    required this.hnt,
    required this.icn,
    required this.controllerr,
    required this.validator,
    required this.keybrd,
  });
  final String hnt;
  final Icon icn;
  final TextEditingController controllerr;
  final String? Function(String?)? validator;
  final TextInputType keybrd;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controllerr,
        validator: validator,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(hnt),
            prefixIcon: icn),
        keyboardType: keybrd);
  }
}

Future<File?> selectimageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (error) {
    snakBarImage(error.toString(), context);
  }
  return image;
}

void snakBarImage(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

void snakbarBarFunction(String content, BuildContext context, Color colour) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: colour,
  ));
}
