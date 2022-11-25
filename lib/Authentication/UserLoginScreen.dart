import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../Boxes.dart';
import '../Homepage/UserHomePage.dart';
import '../LocalStore/AllUserDetails.dart';
import 'AdminLogin.dart';
import 'Signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailnPhone = TextEditingController();
  TextEditingController password = TextEditingController();
  Box<UserDetails>? box;
  List<UserDetails> userDetails = [];
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  void initState() {
    getBox();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Text(
                    "User Login",
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
                                builder: (context) => AdminLoginPage()));
                      },
                      child: Text("Go to Admin Login"))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                  controller: emailnPhone,
                  decoration: InputDecoration(
                    labelText: 'Email or PhoneNumber',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextFormField(
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
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    // errorText:
                    // state.username.invalid ? 'invalid username' : null,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      login();
                    } else {}
                  },
                  child: Text("Login")),
              SizedBox(
                height: 12,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text("Signup"))
            ],
          ),
        ),
      ),
    );
  }

  void getBox() {
    box = Boxes.getAllUser();
    userDetails = box?.values.toSet().toList() as List<UserDetails>;
  }

  login() {
    if (emailnPhone.text.isNotEmpty && password.text.isNotEmpty) {
      bool exists =
          userDetails.any((file) => file.email == emailnPhone.text.toString());
      bool pass =
          userDetails.any((file) => file.password == password.text.toString());
      bool phone =
          userDetails.any((file) => file.phone == emailnPhone.text.toString());
      print(exists);
      // print(pass);
      if (exists == true || phone == true) {
        if (pass == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserHome(
                        emailnPhone: emailnPhone.text,
                        password: password.text,
                      )));
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Login Successful")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Wrong Password")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wrong Email or PhoneNumber")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  }
}
