import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../pColor.dart';

Widget loadingWidget()=>const Center(child: CircularProgressIndicator(color:PColor.themeColor));

void showToast(String mgs)=>Fluttertoast.showToast(
    msg: mgs,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0
);


InputDecoration boxFormDecoration(Size size) => InputDecoration(
  hintText: '',
  contentPadding: EdgeInsets.symmetric(
      vertical: size.width * .04,
      horizontal: size.width * .04),
  //Change this value to custom as you like
  isDense: true,
  hintStyle: formTextStyle(size).copyWith(color: Colors.grey),
  labelStyle: formTextStyle(size).copyWith(color: Colors.grey),
  errorStyle: formTextStyle(size).copyWith(color: Colors.red,fontSize: size.width*.04),
  border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: Colors.grey.shade800,
          width: 1
      )
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: Colors.grey.shade800,
          width: 1
      )
  ),
  disabledBorder: OutlineInputBorder(
      borderRadius:const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: Colors.grey.shade800,
          width: 1
      )
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius:const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: Colors.green.shade800,
          width: 2
      )
  ),
);

TextStyle formTextStyle(Size size) => TextStyle(
    color: Colors.grey.shade800,
    fontSize: size.width*.04,
    fontWeight: FontWeight.w400,
);