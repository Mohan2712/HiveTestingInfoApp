import 'package:flutter/material.dart';

import '../Homepage/AdminHomepage.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  TextEditingController emailnPhone = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                    width: 40,
                  ),
                  Text(
                    "Admin Login",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              TextFormField(
                controller: emailnPhone,
                decoration: InputDecoration(
                  labelText: 'Username',
                  // errorText:
                  // state.username.invalid ? 'invalid username' : null,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  // errorText:
                  // state.username.invalid ? 'invalid username' : null,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: login, child: Text("Login")),
            ],
          ),
        ),
      ),
    );
  }

  login() {
    if (emailnPhone.text == "Admin" && password.text == "0000") {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminHome()));
    } else {
      return WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid credentials")));
      });
    }
  }
}
