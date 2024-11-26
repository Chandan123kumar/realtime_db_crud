import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:random_string/random_string.dart';
import 'package:realtime_db/controller/auth_service/auth_service.dart';
import 'package:realtime_db/model/user_model.dart';
import 'package:realtime_db/view/crud/update_user.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController _nameControoler = TextEditingController();
  TextEditingController _addressControoler = TextEditingController();
  TextEditingController _genderControoler = TextEditingController();
  Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          'Add User',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.pink[510],
                maxRadius: 50,
                child: Icon(
                  Icons.person,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _textField(_nameControoler, 'enter name'),
            _textField(_addressControoler, 'enter address'),
            _textField(_genderControoler, 'enter gender'),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  _addUser();
                },
                child: Text(
                  'Add User',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Card(
        color: Colors.white,
        elevation: 10,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pink)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pink)),
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
        ),
      ),
    );
  }

  void _addUser() async {
    // DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('User');
    final name = _nameControoler.text;
    final address = _addressControoler.text;
    final gender = _genderControoler.text;
    final userId = randomAlphaNumeric(10);

    if (name.isNotEmpty && address.isNotEmpty && gender.isNotEmpty) {
      try {
        var data = UserModel(
            userId: userId, name: name, address: address, gender: gender);
        controller.addUser(data);
        // _databaseReference.child(userId).set(data.toMap());
        Fluttertoast.showToast(msg: 'add data ');
       Navigator.pop(context);
        } catch (ex)
        {
          log('something went wrong');
          Fluttertoast.showToast(msg: '$ex');
        }
      }
    else {
      Fluttertoast.showToast(msg: 'Please fill all the fields');
    }
  }
}
