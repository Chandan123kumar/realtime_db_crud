import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:realtime_db/controller/auth_service/auth_service.dart';
import 'package:realtime_db/model/user_model.dart';

class UpdateUser extends StatefulWidget {
  final String userId;
  final String name;
  final String address;
  final String gender;

  const UpdateUser(
      {super.key, required this.userId, required this.name, required this.address, required this.gender});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  bool isUpdating=false;
  Controller controller=Get.put(Controller());

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    _addressController = TextEditingController(text: widget.address);
    _genderController = TextEditingController(text: widget.gender);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update User',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              maxRadius: 50,
              child: Icon(
                Icons.person_pin,
                size: 50,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _TextField(_nameController),
            _TextField(_addressController),
            _TextField(_genderController),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  _updateData();
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  Widget _TextField(TextEditingController controlller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Card(
        elevation: 10,
        color: Colors.white,
        child: TextFormField(
          controller: controlller,
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pinkAccent)),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pinkAccent)),
          ),
        ),
      ),
    );
  }
  void _updateData()async{
    var name=_nameController.text;
    var address=_addressController.text;
    var gender=_genderController.text;
    if(name.isNotEmpty&& address.isNotEmpty&&gender.isNotEmpty){
      startProgress();
      String id=widget.userId;
      var data=UserModel(userId: id, name: name, address: address, gender: gender);
      await controller.updateData(data);
      stopProgress();
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'User Updated Successfully');
    }
    else{
      Fluttertoast.showToast(msg: 'Please fill all the fields');
    }
  }
  void startProgress(){
    isUpdating=true;
  }
  void stopProgress(){
    isUpdating=false;
  }
}
