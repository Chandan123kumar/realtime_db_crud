import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:realtime_db/controller/auth_service/auth_service.dart';
import 'package:realtime_db/model/user_model.dart';
import 'package:realtime_db/view/crud/add_user.dart';

import '../crud/update_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  List<UserModel> listOfData = [];
  bool isloading = false;
  Controller controller = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    _getData();
    startProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.pinkAccent,
              Colors.deepPurple,
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.pinkAccent,
              title: Text(
                'RealTime Database',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.grey,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddUser()));
              },
              label: const Text('Add'),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: SafeArea(
              child: isloading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : listOfData.isNotEmpty
                      ? ListView.builder(
                          itemCount: listOfData.length,
                          itemBuilder: (context, index) {
                            final data = listOfData[index];
                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: InkWell(
                                  onTap: () {
                                    _deleteDialog(listOfData[index].userId);
                                  },
                                  onLongPress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateUser(
                                                  name: listOfData[index].name,
                                                  address:
                                                      listOfData[index].address,
                                                  gender:
                                                      listOfData[index].gender,
                                                  userId:
                                                      listOfData[index].userId,
                                                )));
                                  },
                                  child: Card(
                                    color: Colors.white60,
                                    elevation: 10,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: ClipOval(
                                          child: Icon(Icons.person),
                                        ),
                                      ),
                                      title: Text(
                                        listOfData[index].name,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        listOfData[index].address,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      trailing: Text(listOfData[index].gender),
                                    ),
                                  ),
                                ));
                          })
                      : const Text('no data found'),
            )));
  }

  Future<void> _getData() async {
    databaseReference.child('User').onValue.listen((event) {
      final dataSnapshot = event.snapshot.value as Map<dynamic, dynamic>?;
      final List<UserModel> tempDataList = [];
      if (dataSnapshot != null) {
        dataSnapshot.forEach((key, value) {
          final userList = UserModel.fromjson(Map<String, dynamic>.from(value));
          tempDataList.add(userList);
        });
      }
      setState(() {
        listOfData = tempDataList;
        stopProgress();
      });
    });
  }

  void startProgress() {
    setState(() {
      isloading = true;
    });
  }

  void stopProgress() {
    setState(() {
      isloading = false;
    });
  }

  void _deleteDialog(String userId) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                controller.deleteItem(userId);
                _getData();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
