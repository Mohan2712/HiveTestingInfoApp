import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testinginfo/Boxes.dart';

import '../LocalStore/AllUserDetails.dart';
import 'UserLoginScreen.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  Box<UserDetails>? box;
  List<UserDetails> userAll = [];
  bool isShow = false;
  XFile? profilePic;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  dynamic _pickImageError;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  @override
  void initState() {
    openBox();
    super.initState();
  }

  @override
  void dispose() {
    // Hive.close();
    super.dispose();
  }

  Future<void> _onProfilePicPressed(ImageSource source,
      {BuildContext? context}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFileList = await _picker.pickImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
          source: source,
        );
        setState(() {
          profilePic = pickedFileList;
          print("IMAGE PICKED${profilePic}");
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth if desired'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight if desired'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality if desired'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _profileImages(BuildContext context) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      Navigator.pop(context);
      return retrieveError;
    }
    if (profilePic != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 22.0),
        child: SizedBox(
          height: 150,
          width: 100,
          child: Semantics(
            label: 'image_picker_example_picked_images',
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.file(
                File(profilePic!.path),
                height: 100,
                width: 100,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 85,
                      ),
                      Text(
                        "Signup",
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else
                        return null;
                    },
                    controller: name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Please enter a valid email",
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: validateMobile,
                    keyboardType: TextInputType.phone,
                    controller: phoneNumber,
                    decoration: InputDecoration(
                      labelText: 'PhoneNumber',
                      // errorText:
                      // state.username.invalid ? 'invalid username' : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else if (value.length < 6) {
                        return "Password should be atleast 6 characters";
                      } else if (value.length > 15) {
                        return "Password should not be greater than 15 characters";
                      } else
                        return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    controller: password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                    ),
                    child: Text(
                      'Your Photo',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                    ),
                    child: SizedBox(
                      width: 316,
                      height: 48,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            //color: AppColors().lightBlack
                                            ))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () => {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload Image',
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  _onProfilePicPressed(
                                    ImageSource.gallery,
                                    context: context,
                                  );
                                },
                                icon: Icon(Icons.add_photo_alternate_outlined),
                                color: Colors.black,
                              ),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _profileImages(context),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate() &&
                            profilePic!.path.isNotEmpty) {
                          print("Validated");
                          saveData(profilePic!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Signup Successful")));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } else {
                          print("Not Validated");
                        }
                      },
                      child: Text("Signup")),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text("Back to Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onPickImage() {}
  String? validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  Future<void> openBox() async {
    box = Boxes.getAllUser();
    // box = Boxes.getAllBatches();
    // await box?.clear();
    debugPrint("wwwwwwwwwwwwwwwwwkekekkkkkkkkk${box?.values}");
    // await box.deleteAll(box.keys);
  }

  saveData(XFile image) {
    File file = File(image.path);
    var imageBytes = file.readAsBytesSync();
    print('See your Images ${imageBytes}');
    // userAll.add();
    box?.add(UserDetails(
        name: name.text,
        email: email.text,
        phone: phoneNumber.text,
        password: password.text,
        profilePic: imageBytes));

    userAll = box?.values.toSet().toList() ?? [];
    print("adding ssssss ${userAll}");
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
