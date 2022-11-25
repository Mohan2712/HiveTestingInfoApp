import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../Authentication/UserLoginScreen.dart';
import '../Boxes.dart';
import '../LocalStore/AllUserDetails.dart';
import 'UserEdit.dart';

class UserHome extends StatefulWidget {
  String? emailnPhone;
  String? password;
  UserHome({Key? key, required this.emailnPhone, required this.password})
      : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userPass;
  Uint8List? profilePic;
  List<UserDetails> userDetails = [];
  List<UserDetails> specificUser = [];
  Box<UserDetails>? box;
  int? indexvalue;
  @override
  void initState() {
    pickDataFromList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    "User HomePage",
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text("Logout"))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: specificUser.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserBy(
                                                  email: specificUser[index]
                                                      .email
                                                      .toString(),
                                                  name: specificUser[index]
                                                      .name
                                                      .toString(),
                                                  phoneNumber:
                                                      specificUser[index]
                                                          .phone
                                                          .toString(),
                                                  Password: specificUser[index]
                                                      .password
                                                      .toString(),
                                                  index: indexvalue,
                                                  profilePic:
                                                      specificUser[index]
                                                          .profilePic,
                                                )));
                                  },
                                  icon: Icon(Icons.edit)),
                              SizedBox(
                                  child: Image.memory(
                                      specificUser[index].profilePic ??
                                          Uint8List(1)),
                                  width: 100,
                                  height: 100),
                              Row(
                                children: [
                                  Text("Name:"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(specificUser[index].name.toString())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Email:"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(specificUser[index].email.toString())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("PhoneNumber:"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(specificUser[index].phone.toString())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Password:"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(specificUser[index].password.toString())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          )),
        ),
      ),
    );
  }

  void pickDataFromList() {
    box = Boxes.getAllUser();
    userDetails = box?.values.toSet().toList() as List<UserDetails>;
    specificUser = userDetails
        .where((element) =>
            element.email == widget.emailnPhone ||
            element.phone == widget.emailnPhone &&
                element.password == widget.password)
        .toList();
    indexvalue = userDetails.indexWhere((element) =>
        element.email == widget.emailnPhone ||
        element.phone == widget.emailnPhone &&
            element.password == widget.password);
    // for (final q in specificUser) {
    //   userName = q.name;
    //   userPass = q.password;
    //   userEmail = q.email;
    //   userPhone = q.phone;
    //   profilePic = q.profilePic;
    // }
  }
}
