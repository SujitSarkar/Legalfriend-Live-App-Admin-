import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<bool> uploadImageList(List<dynamic>? previousImageLinks, List<File> imageList)async{
    try{
      List<String> _downloadUrls = [];
      final FirebaseStorage storageReference = FirebaseStorage.instance;
      ///Delete previous images from Firestore
      if(previousImageLinks!=null && previousImageLinks.isNotEmpty){
        await Future.forEach(previousImageLinks, (element)async{
          storageReference.refFromURL(element as String).delete();
        });
      }
      ///Upload new image list into Storage
      await Future.forEach(imageList, (File image) async {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('serial_image')
            .child('${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask = ref.putFile(image);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        final url = await taskSnapshot.ref.getDownloadURL();
        _downloadUrls.add(url);
      });
      ///Insert new image link into Firestore
      await FirebaseFirestore.instance.collection('LiveSerial').doc('123456').update({
        'image_list': _downloadUrls,
        'image_update_date': DateTime.now().millisecondsSinceEpoch
      });
      return true;
    }on SocketException{
      showToast('No internet connection');
      return false;
    } catch(error){
      return false;
    }
  }
}