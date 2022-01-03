import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_admin_app/home_page.dart';
import 'package:live_admin_app/widget_tile/bottom_tile.dart';
import 'package:live_admin_app/widget_tile/gradient_button.dart';
import 'package:live_admin_app/widget_tile/loading_widget.dart';

import 'controller/database_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading=false;
  final TextEditingController _phone= TextEditingController();
  final TextEditingController _password= TextEditingController();
  bool _obscure=true;
  int _radioValue=0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _bodyUI(size),
      bottomNavigationBar:const BottomTile(),
    );
  }

  Widget _bodyUI(Size size)=>SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*.05),
        child: Column(
          children: [
            SizedBox(height: size.width*.1),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                    fontSize: size.width*.05,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold
                ),
                children: const [
                  TextSpan(text: 'মহানগর দায়রা জজ আদালত, ঢাকা।\n'),
                  TextSpan(text: 'ফৌজদারি বিবিধ মামলা'),
                ],
              ),
            ),
            SizedBox(height: size.width*.2),

            ///Username
            TextFormField(
              controller: _phone,
              style: TextStyle(fontSize: size.width*.04),
              decoration: boxFormDecoration(size).copyWith(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: size.width*.04),

            ///Password
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              style: TextStyle(fontSize: size.width*.04),
              decoration: boxFormDecoration(size).copyWith(
                  labelText: 'Password',
                  suffixIcon: IconButton(onPressed: (){
                    setState(()=> _obscure=!_obscure);
                  }, icon: Icon(_obscure? CupertinoIcons.eye_slash:CupertinoIcons.eye))
              ),
            ),
            SizedBox(height: size.width*.04),

            ///Radio Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio(value: 1, groupValue: _radioValue, onChanged: (int? val){
                      setState(()=>_radioValue=val!);
                    }),
                    Text('Admin',
                        style: TextStyle(fontSize: size.width * .04))
                  ],
                ),
                Row(
                  children: [
                    Radio(value: 2, groupValue: _radioValue, onChanged: (int? val){
                      setState(()=>_radioValue=val!);
                    }),
                    Text('Sub-Admin',
                        style: TextStyle(fontSize: size.width * .04))
                  ],
                )
              ],
            ),
            SizedBox(height: size.width*.03),

            _isLoading
                ?loadingWidget()
                : GradientButton(
              onPressed: ()=>_login(),
              child: Text('Login',
                  style: TextStyle(fontSize: size.width * .06)),
              height: size.width * .12,
              width: size.width * .8,
              borderRadius: size.width * .03,
              gradientColors:const [
                Color(0xffCB081B),
                Color(0xff9B0C17),
              ],
            ),
          ],
        ),
      ),
    ),
  );


  void _login()async{
    if(_phone.text.isNotEmpty){
      if( _password.text.isNotEmpty){
        if(_radioValue!=0){
          ///For Admin Login
          if(_radioValue==1){
            setState(()=> _isLoading=true);
            DatabaseController().validateAdmin(_phone.text,_password.text).then((value)async{
              if(value){
                setState(()=> _isLoading=false);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()), (route) => false);
              }else{
                setState(()=> _isLoading=false);
                showToast('Wrong username or password');
              }
            });
          }
          ///For Sub-Admin Login
          else if(_radioValue==2){
            setState(()=> _isLoading=true);
            DatabaseController().validateSubAdmin(_phone.text, _password.text).then((value)async{
              if(value){
                setState(()=> _isLoading=false);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()), (route) => false);
              }else{
                setState(()=> _isLoading=false);
                showToast('Wrong username or password');
              }
            });
          }

        }else {showToast('Select Admin or Sub-Admin');}
      }else {showToast('Enter Password');}
    }else {showToast('Enter Username Number');}
  }
}
