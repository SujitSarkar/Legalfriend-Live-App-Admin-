import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_admin_app/go_live_page.dart';
import 'package:live_admin_app/widget_tile/bottom_tile.dart';
import 'package:live_admin_app/widget_tile/gradient_button.dart';
import 'package:live_admin_app/widget_tile/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading=false;

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
      child: SizedBox(
        width: size.width,
        child: Column(
          children: [
            SizedBox(height: size.width*.1),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: size.width*.06,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
                ),
                children: const [
                  TextSpan(text: 'মহানগর দায়রা জজ আদালত, ঢাকা।\n'),
                  TextSpan(text: 'ফৌজদারি বিবিধ মামলা'),
                ],
              ),
            ),
            SizedBox(height: size.width*.08),

            Text('serial no.',textAlign:TextAlign.center,style: TextStyle(color: Colors.grey.shade300,
                fontWeight: FontWeight.bold,
                fontSize: size.width * .08)),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('LiveSerial').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: size.width*.25),
                              height:size.width * .18,
                              color: Colors.grey.shade300,
                              alignment: Alignment.center,
                              child: Text(doc['serial_number'].toString(),
                                  style: TextStyle(color: Colors.grey.shade600,fontSize: size.width*.15,fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: size.width*.1),

                            doc['is_live']
                                ?Text('[ লাইভ চালু আছে ]',textAlign:TextAlign.center,style: TextStyle(color: Colors.green,
                                fontSize: size.width * .1))
                                :Text('[ লাইভ বন্ধ আছে ]',textAlign:TextAlign.center,style: TextStyle(color: const Color(0xffFF0000),
                                fontSize: size.width * .1)),

                            SizedBox(height: size.width*.3),

                            _isLoading
                                ?loadingWidget()
                                : GradientButton(
                              onPressed: ()async{
                                setState(()=>_isLoading=true);
                                await FirebaseFirestore.instance.collection('LiveSerial').doc('123456').update({
                                  'is_live': true,
                                });
                                setState(()=>_isLoading=false);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const GoLivePage()));
                              },
                              child: Text(doc['is_live']?'Update Serial No':'GO LIVE',
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
                        );
                      });
                } else {
                  return Container(
                    height:size.width * .18,
                    width: size.width * .5,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                  );
                }
              },
            ),

          ],
        ),
      ),
    ),
  );
}
