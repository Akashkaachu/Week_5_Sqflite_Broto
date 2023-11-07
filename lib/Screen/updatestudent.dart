import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wk5/Screen/save.dart';
import 'package:wk5/Screen/search.dart';
import 'package:wk5/Screen/studentmodel.dart';
import 'package:wk5/database/databasesqflite.dart';

class UpdateStudentDetails extends StatefulWidget {
  const UpdateStudentDetails(
      {super.key,
      required this.id,
      required this.name,
      required this.roll,
      required this.department,
      required this.number,
      required this.imagesrc});
  final int id;
  final String name;
  final int roll;
  final String department;
  final double number;
  final dynamic imagesrc;

  @override
  State<UpdateStudentDetails> createState() => _UpdateStudentDetailsState();
}

class _UpdateStudentDetailsState extends State<UpdateStudentDetails> {
  final formkey = GlobalKey<FormState>();
  File? selectedImage;
  late TextEditingController idEditingControllerr;
  late TextEditingController nameEditingControllerr;
  late TextEditingController rollEditingControllerr;
  late TextEditingController departmentEditingControllerr;
  late TextEditingController phoneEditingControllerr;
  @override
  void initState() {
    int phone = widget.number.toInt();
    print(widget.roll);
    nameEditingControllerr = TextEditingController(text: widget.name);
    idEditingControllerr = TextEditingController(text: widget.id.toString());
    rollEditingControllerr =
        TextEditingController(text: widget.roll.toString());
    departmentEditingControllerr =
        TextEditingController(text: widget.department);
    phoneEditingControllerr = TextEditingController(text: phone.toString());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Update Student Details ")),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: <Color>[Colors.purple, Colors.blue])),
          ),
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
                      File? pickedimage = await selectimageFromGallery(context);
                      setState(() {
                        selectedImage = pickedimage;
                      });
                    },
                    child: CircleAvatar(
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : FileImage(File(widget.imagesrc!)),
                      radius: 60,
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
                      icn: Icon(Icons.person),
                      controllerr: idEditingControllerr,
                      keybrd: TextInputType.name),
                  SizedBox(height: 20),
                  txtformfld(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter The Name";
                        } else {
                          return null;
                        }
                      },
                      hnt: "Student Name",
                      icn: Icon(Icons.person),
                      controllerr: nameEditingControllerr,
                      keybrd: TextInputType.text),
                  SizedBox(height: 20),
                  txtformfld(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your Roll  Number";
                      } else {
                        return null;
                      }
                    },
                    controllerr: rollEditingControllerr,
                    hnt: "Roll Number",
                    icn: Icon(Icons.numbers),
                    keybrd: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  txtformfld(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Department";
                        } else {
                          return null;
                        }
                      },
                      hnt: "Department",
                      icn: Icon(Icons.school),
                      controllerr: departmentEditingControllerr,
                      keybrd: TextInputType.text),
                  SizedBox(height: 20),
                  txtformfld(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Phone Number";
                      } else if (value.length < 10 || value.length > 10) {
                        return "Enter Valid Number";
                      }
                      return null;
                    },
                    controllerr: phoneEditingControllerr,
                    hnt: "Phone Number",
                    icn: Icon(Icons.phone),
                    keybrd: TextInputType.phone,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                      height: 40,
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              if (selectedImage != null ||
                                  widget.imagesrc != null) {
                                final student = StudentModel(
                                    id: int.parse(idEditingControllerr.text),
                                    name: nameEditingControllerr.text,
                                    roll:
                                        int.parse(rollEditingControllerr.text),
                                    department:
                                        departmentEditingControllerr.text,
                                    imageurl: selectedImage == null
                                        ? widget.imagesrc
                                        : selectedImage!.path,
                                    number: phoneEditingControllerr.text);
                                await updateStudentDetailsFromDB(student);
                                snackBarFunction(context,
                                    "Successfully Updated", Colors.green);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchPage(),
                                ));
                              } else {
                                snakbarBarFunction(
                                    "Please Select Students Image",
                                    context,
                                    Colors.red);
                              }
                            }
                          },
                          child: Text("Update"))),
                ]),
              ),
            ),
          ),
        ));
  }
}
