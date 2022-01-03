import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_admin_app/widget_tile/loading_widget.dart';

class DatabaseController{

  Future<bool> validateAdmin(String phone, String password)async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Admin')
          .where('phone', isEqualTo: phone).get();
      final List<QueryDocumentSnapshot> user = snapshot.docs;
      if(user.isNotEmpty && user[0].get('password')==password){
        return true;
      }else{
        return false;
      }
    } on SocketException{
      showToast('No Internet Connection !');
      return false;
    } catch(error){
      showToast(error.toString());
      return false;
    }
  }

  Future<bool> validateSubAdmin(String username, String password)async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('SubAdmin')
          .where('name', isEqualTo: username).get();
      final List<QueryDocumentSnapshot> user = snapshot.docs;
      if(user.isNotEmpty && user[0].get('password')==password){
        return true;
      }else{
        return false;
      }
    } on SocketException{
      showToast('No Internet Connection !');
      return false;
    } catch(error){
      showToast(error.toString());
      return false;
    }
  }
}