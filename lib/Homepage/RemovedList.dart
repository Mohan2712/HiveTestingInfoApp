import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../Boxes.dart';
import '../LocalStore/RemovedList.dart';

// class RemovedUser extends StatefulWidget {
//   const RemovedUser({Key? key}) : super(key: key);
//
//   @override
//   State<RemovedUser> createState() => _RemovedUserState();
// }
//
// class _RemovedUserState extends State<RemovedUser> {
//   Box<RemovedList>? removedBox;
//   List<RemovedList> removedUsers = [];
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//
//           ],
//         ),
//       ),
//     );
//   }
// }

class RemovedUser extends StatelessWidget {
  Box<RemovedList>? removedBox;
  List<RemovedList> removedUsers = [];
  RemovedUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
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
                      width: 70,
                    ),
                    Text(
                      "Removed User",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                ValueListenableBuilder<Box>(
                    valueListenable: Boxes.getAllRemovedUser().listenable(),
                    builder: (context, box, _) {
                      removedUsers =
                          box.values.toSet().toList() as List<RemovedList>;
                      return removedUsers.isEmpty
                          ? Center(child: Text('Empty'))
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: removedUsers.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                          child: Image.memory(
                                              removedUsers[index].profilePic!),
                                          width: 100,
                                          height: 100),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(removedUsers[index]
                                              .name
                                              .toString()),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(removedUsers[index]
                                              .email
                                              .toString()),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(removedUsers[index]
                                              .phone
                                              .toString()),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(removedUsers[index]
                                              .password
                                              .toString()),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
