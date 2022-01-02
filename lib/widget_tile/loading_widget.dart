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