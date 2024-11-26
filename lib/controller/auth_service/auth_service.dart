import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:realtime_db/model/user_model.dart';

class Controller extends GetxController {
   DatabaseReference databaseReference = FirebaseDatabase.instance.ref('User');

  Future<void> addUser(UserModel userData) async {

      try {
       await  databaseReference.child(userData.userId.toString()).set(userData.toMap());
        Fluttertoast.showToast(msg: 'save data');
      } catch (ex) {
        log('something went wrong');
        Fluttertoast.showToast(msg: 'Error $ex');

      }
    }
    Future<void> updateData(UserModel userModel)async{
        final id=userModel.userId;
        try{
          databaseReference.child(id).update(userModel.toMap());
          Fluttertoast.showToast(msg: 'User Updated successfullly');
        }catch(ex){
          Fluttertoast.showToast(msg: '$ex');
        }
    }

    Future<void>deleteItem(String id)async{
    final data =await databaseReference.child(id).get();
    try{
      if(data.exists){
        databaseReference.child(id).remove();
        Fluttertoast.showToast(msg: 'User deletd successfully');
      }
      else{
        Fluttertoast.showToast(msg: 'User with this id does not exist');
      }
    }catch(ex){
      Fluttertoast.showToast(msg: '$ex');
    }
    }
  }
