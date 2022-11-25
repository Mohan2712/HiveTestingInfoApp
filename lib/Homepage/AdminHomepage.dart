import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:testinginfo/Authentication/UserLoginScreen.dart';

import '../Boxes.dart';
import '../LocalStore/AllUserDetails.dart';
import '../LocalStore/RemovedList.dart';
import 'EditUser.dart';
import 'RemovedList.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<UserDetails> userDetails = [];
  List<UserDetails> filterDetails = [];
  Box<UserDetails>? box;
  Box<RemovedList>? removedBox;
  List<RemovedList> removedUsers = [];
  @override
  void initState() {
    getBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: ScrollPhysics(),
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
                    "Admin HomePage",
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
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RemovedUser()));
                  },
                  child: Text("See removed user")),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Search', suffixIcon: Icon(Icons.search)
                          // errorText:
                          // state.username.invalid ? 'invalid username' : null,
                          ),
                      onChanged: (value) {
                        _runFilter(value);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    filterDetails.isEmpty
                        ? Center(child: Text('Empty'))
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filterDetails.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        child: Image.memory(
                                            filterDetails[index].profilePic!),
                                        width: 100,
                                        height: 100),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(filterDetails[index]
                                            .name
                                            .toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(filterDetails[index]
                                            .email
                                            .toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(filterDetails[index]
                                            .phone
                                            .toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(filterDetails[index]
                                            .password
                                            .toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              removedBox?.add(RemovedList(
                                                  name: filterDetails[index]
                                                      .name
                                                      .toString(),
                                                  email: filterDetails[index]
                                                      .email
                                                      .toString(),
                                                  phone: filterDetails[index]
                                                      .phone
                                                      .toString(),
                                                  password: filterDetails[index]
                                                      .password
                                                      .toString(),
                                                  profilePic:
                                                      filterDetails[index]
                                                          .profilePic!));
                                              box?.deleteAt(index);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Deleted Successfully")));
                                              Future.delayed(
                                                  Duration(seconds: 4));
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminHome()));
                                            },
                                            icon: Icon(Icons.delete)),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) => EditUser(
                                                                email: userDetails[
                                                                        index]
                                                                    .email
                                                                    .toString(),
                                                                name: userDetails[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                phoneNumber:
                                                                    userDetails[
                                                                            index]
                                                                        .phone
                                                                        .toString(),
                                                                Password: userDetails[
                                                                        index]
                                                                    .password
                                                                    .toString(),
                                                                index: index,
                                                                profilePic:
                                                                    userDetails[
                                                                            index]
                                                                        .profilePic,
                                                              )));
                                            },
                                            icon: Icon(Icons.edit)),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  // Future<void> openBox() async {
  //   box = await Hive.openBox<UserDetails>("GetUser");
  //   // box = Boxes.getAllBatches();
  //   //await box?.clear();
  //   debugPrint("wwwwwwwwwwwwwwwwwkekekkkkkkkkk${box?.values}");
  //   // await box.deleteAll(box.keys);
  // }

  void _runFilter(String enteredKeyword) {
    List<UserDetails> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = userDetails;
    } else {
      results = userDetails
          .where((user) =>
              user.name!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user.email!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.phone!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      //we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      filterDetails = results;
    });
  }

  void getBox() {
    box = Boxes.getAllUser();
    userDetails = box?.values.toSet().toList() as List<UserDetails>;
    filterDetails = userDetails;
    removedBox = Boxes.getAllRemovedUser();
  }
}
