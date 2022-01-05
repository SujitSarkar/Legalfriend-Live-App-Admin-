import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_admin_app/pColor.dart';
import 'package:live_admin_app/photo_view_page.dart';
import 'package:live_admin_app/upload_image_page.dart';
import 'package:live_admin_app/widget_tile/bottom_tile.dart';
import 'package:live_admin_app/widget_tile/gradient_button.dart';
import 'package:live_admin_app/widget_tile/live_page_app_bar.dart';
import 'package:live_admin_app/widget_tile/loading_widget.dart';
import 'package:live_admin_app/widget_tile/solid_button.dart';

class GoLivePage extends StatefulWidget {
  const GoLivePage({Key? key}) : super(key: key);

  @override
  _GoLivePageState createState() => _GoLivePageState();
}

class _GoLivePageState extends State<GoLivePage> {
  bool _isLoading = false;
  final List<int> _serialNumberList = [];
  int _selectedSerial = 0;
  bool _showSerialWindow = false;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= 200; i++) {
      _serialNumberList.add(i);
    }
    setState(() {});
  }

//   onWillPop: () async {
//   await _closeLive();
//   return true;
// },
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _showSerialWindow ? _showSerialListWidget(size) : _bodyUI(size),
        ],
      ),
      bottomNavigationBar: const BottomTile(),
    );
  }

  Widget _bodyUI(Size size) => SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LiveAppBar(
                    child: Text('LIVE',
                        style: TextStyle(
                            fontSize: size.width * .06,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
                SizedBox(height: size.width * .1),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: size.width * .06,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                    children: const [
                      TextSpan(text: 'মহানগর দায়রা জজ আদালত, ঢাকা।\n'),
                      TextSpan(text: 'ফৌজদারি বিবিধ মামলা'),
                    ],
                  ),
                ),
                SizedBox(height: size.width * .1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                  child: Text(
                    'বিবিধ মামলার সিরিয়াল নম্বর',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: size.width * .07,
                        color: PColor.livePageBgColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.width * .01),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('LiveSerial')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return Column(
                              children: [
                                SolidButton(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                            width: size.width * .8,
                                            child: Text('PREVIOUS',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: PColor.yellowColor,
                                                    fontSize:
                                                        size.width * .08))),
                                        Positioned(
                                            left: 5.0,
                                            child: Icon(
                                              CupertinoIcons.arrowtriangle_left,
                                              color: Colors.white,
                                              size: size.width * .1,
                                            ))
                                      ],
                                    ),
                                    onPressed: () async {
                                      if (doc['serial_number'] != 0) {
                                        if (doc['is_live']) {
                                          await FirebaseFirestore.instance
                                              .collection('LiveSerial')
                                              .doc('123456')
                                              .update({
                                            'serial_number':
                                                doc['serial_number'] - 1,
                                            'last_update_date': DateTime.now()
                                                .millisecondsSinceEpoch
                                          });
                                        } else {
                                          showToast('লাইভ বন্ধ আছে');
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    height: size.width * .12,
                                    width: size.width * .8),
                                SizedBox(height: size.width * .02),
                                InkWell(
                                  onTap: () {
                                    if (doc['is_live']) {
                                      setState(() => _showSerialWindow = true);
                                      Future.delayed(
                                              const Duration(milliseconds: 100))
                                          .then((value) {
                                        _animateToIndex(doc['serial_number']);
                                      });
                                    } else {
                                      showToast('লাইভ বন্ধ আছে');
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    height: size.width * .3,
                                    width: size.width * .8,
                                    color: PColor.livePageBgColor,
                                    alignment: Alignment.center,
                                    child: Text(doc['serial_number'].toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * .27,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                SizedBox(height: size.width * .02),
                                SolidButton(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                            width: size.width * .8,
                                            child: Text('NEXT',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: PColor.yellowColor,
                                                    fontSize:
                                                        size.width * .08))),
                                        Positioned(
                                            right: 5.0,
                                            child: Icon(
                                              CupertinoIcons
                                                  .arrowtriangle_right,
                                              color: Colors.white,
                                              size: size.width * .1,
                                            ))
                                      ],
                                    ),
                                    onPressed: () async {
                                      if (doc['is_live']) {
                                        await FirebaseFirestore.instance
                                            .collection('LiveSerial')
                                            .doc('123456')
                                            .update({
                                          'serial_number':
                                              doc['serial_number'] + 1,
                                          'last_update_date': DateTime.now()
                                              .millisecondsSinceEpoch
                                        });
                                      } else {
                                        showToast('লাইভ বন্ধ আছে');
                                        Navigator.pop(context);
                                      }
                                    },
                                    height: size.width * .12,
                                    width: size.width * .8),
                                SizedBox(height: size.width * .04),
                                doc['image_list'].isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * .1),
                                        child: SizedBox(
                                          height: size.width * .25,
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  doc['image_list'].length,
                                              itemBuilder: (_, index) =>
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PhotoViewPage(imageList: doc['image_list']))),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          doc['image_list']
                                                              [index],
                                                      placeholder: (context,
                                                              url) =>
                                                          Icon(Icons.image,
                                                              size: size.width *
                                                                  .25,
                                                              color:
                                                                  Colors.grey),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error,
                                                              size: size.width *
                                                                  .25),
                                                    ),
                                                  ),
                                              separatorBuilder: (_, index) =>
                                                  SizedBox(
                                                      width: size.width * .04)),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: size.width * .1),
                                GradientButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadImagePage(
                                                  imageLinks: doc['image_list'],
                                                )));
                                  },
                                  child: Text('UPLOAD IMAGE',
                                      style: TextStyle(
                                          fontSize: size.width * .06)),
                                  height: size.width * .12,
                                  width: size.width * .8,
                                  borderRadius: size.width * .03,
                                  gradientColors: const [
                                    Color(0xff00486C),
                                    Color(0xff266382),
                                  ],
                                ),
                                SizedBox(height: size.width * .04),
                              ],
                            );
                          });
                    } else {
                      return Container(
                        height: size.width * .3,
                        width: size.width * .8,
                        color: PColor.livePageBgColor,
                        alignment: Alignment.center,
                        child: Text('Loading...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .05,
                                fontWeight: FontWeight.bold)),
                      );
                    }
                  },
                ),
                _isLoading
                    ? loadingWidget()
                    : GradientButton(
                        onPressed: () => _closeLive(),
                        child: Text('CLOSE LIVE',
                            style: TextStyle(fontSize: size.width * .06)),
                        height: size.width * .12,
                        width: size.width * .8,
                        borderRadius: size.width * .03,
                        gradientColors: const [
                          Color(0xffCB081B),
                          Color(0xff9B0C17),
                        ],
                      ),
              ],
            )),
      ));

  Widget _showSerialListWidget(Size size) => Padding(
        padding: EdgeInsets.all(size.width * .06),
        child: Column(
          children: [
            Expanded(
              child: ListWheelScrollView(
                controller: _scrollController,
                itemExtent: 70,
                useMagnifier: true,
                diameterRatio: 1.5,
                squeeze: 1,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) =>
                    setState(() => _selectedSerial = index),
                children: _serialNumberList
                    .map((e) => Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.green, width: 1)),
                          child: Text(
                            e.toString(),
                            style: TextStyle(
                              fontSize: size.width * .1,
                              color: e == _selectedSerial
                                  ? Colors.green
                                  : PColor.livePageBgColor,
                              fontWeight: e == _selectedSerial
                                  ? FontWeight.w900
                                  : FontWeight.w400,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => setState(() => _showSerialWindow = false),
                    child: const Text('Cancel')),
                _isLoading
                    ? loadingWidget()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          await FirebaseFirestore.instance
                              .collection('LiveSerial')
                              .doc('123456')
                              .update({
                            'serial_number': _selectedSerial,
                            'last_update_date':
                                DateTime.now().millisecondsSinceEpoch
                          });
                          setState(() {
                            _isLoading = false;
                            _showSerialWindow = false;
                          });
                        },
                        child: const Text('OK')),
              ],
            )
          ],
        ),
      );

  void _animateToIndex(int index) {
    _scrollController.animateToItem(index,
        duration: const Duration(milliseconds: 600), curve: Curves.linear);
  }

  Future<void> _closeLive() async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance
        .collection('LiveSerial')
        .doc('123456')
        .update({
      'is_live': false,
      'last_update_date': DateTime.now().millisecondsSinceEpoch
    });
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }
}
