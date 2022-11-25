import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import '../Boxes.dart';
import '../LocalStore/AllUserDetails.dart';
import 'UserHomePage.dart';

class UserBy extends StatefulWidget {
  String? name;
  String? phoneNumber;
  String? email;
  String? Password;
  int? index;
  Uint8List? profilePic;

  UserBy({
    Key? key,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.Password,
    required this.index,
    required this.profilePic,
  }) : super(key: key);

  @override
  State<UserBy> createState() => _UserByState();
}

class _UserByState extends State<UserBy> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  Box<UserDetails>? box;
  // Hive.box("GetUser");
  @override
  void initState() {
    email.text = widget.email.toString();
    password.text = widget.Password.toString();
    phoneNumber.text = widget.phoneNumber.toString();
    name.text = widget.name.toString();
    print('${widget.index}');
    box = Boxes.getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
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
            ElevatedButton(onPressed: updateData, child: Text("Update")),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }

  String? validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  updateData() {
    box?.putAt(
        widget.index!,
        UserDetails(
            name: name.text,
            email: email.text,
            phone: phoneNumber.text,
            password: password.text,
            profilePic: widget.profilePic));

    List<UserDetails> details =
        box?.values.toSet().toList() as List<UserDetails>;

    for (final q in details) {
      print("${q.name}");
    }
    Future.delayed(Duration(seconds: 4));
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UserHome(
                  emailnPhone: email.text,
                  password: password.text,
                )));
  }
}
