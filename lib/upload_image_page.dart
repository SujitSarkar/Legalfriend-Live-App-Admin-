import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_admin_app/controller/database_controller.dart';
import 'package:live_admin_app/widget_tile/bottom_tile.dart';
import 'package:live_admin_app/widget_tile/live_page_app_bar.dart';
import 'package:live_admin_app/widget_tile/loading_widget.dart';


class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key,this.imageLinks}) : super(key: key);
  final List<dynamic>? imageLinks;

  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {

  List<File> _imageList=[];
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _bodyUI(size),
      bottomNavigationBar: const BottomTile(),
    );
  }

  Widget _bodyUI(Size size)=>SafeArea(
      child: Column(
        children: [
          LiveAppBar(
              child: Text('LIVE',
                  style: TextStyle(
                      fontSize: size.width * .06,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),

         Expanded(
           child: SingleChildScrollView(
             child: Column(
               children: [
                 SizedBox(height: size.width * .05),

                 ///Image picker button
                 Padding(
                   padding: EdgeInsets.symmetric(horizontal: size.width*.04),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       _isLoading?
                       const CircularProgressIndicator()
                           :ElevatedButton(onPressed: ()=>_saveImage(),
                           child: Text('Save')),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           InkWell(
                             onTap: (){
                               _imageList.clear();
                               setState(() {});
                             },
                             child: DottedBorder(
                               color: Colors.redAccent,
                               strokeWidth: 1,
                               child: Padding(
                                 padding: EdgeInsets.all(size.width*.02),
                                 child: Icon(CupertinoIcons.clear,color: Colors.redAccent),
                               ),
                             ),
                           ),
                           SizedBox(width: size.width*.05),
                           InkWell(
                             onTap: ()=>_pickImage(),
                             child: DottedBorder(
                               color: Theme.of(context).primaryColor,
                               strokeWidth: 1,
                               child: Padding(
                                 padding: EdgeInsets.all(size.width*.02),
                                 child: Icon(CupertinoIcons.add,color: Theme.of(context).primaryColor),
                               ),
                             ),
                           ),
                         ],
                       )
                     ],
                   ),
                 ),
                 SizedBox(height: size.width * .05),

                 ListView.separated(
                   itemCount: _imageList.length,
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemBuilder: (context,index)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: size.width*.04),
                     child: Image.file(_imageList[index]),
                   ),
                   separatorBuilder: (_,index)=>SizedBox(height: size.width*.04),
                 ),
                 SizedBox(height: size.width * .05),
               ],
             ),
           ),
         )
        ],
      )
  );

  void _saveImage()async{
    setState(()=>_isLoading=true);
    showToast('Saving...');
    bool result=await DatabaseController().uploadImageList(widget.imageLinks!, _imageList);
    if(result){
      setState(()=>_isLoading=false);
      showToast('Images Saved Successfully');
    }else{
      setState(()=>_isLoading=false);
      showToast('Failed Try Again');
    }
  }

  void _pickImage()async{
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 50);
    if(images!=null){
      for(var element in images){
        _imageList.add(File(element.path));
      }
      setState(() {});
      print(_imageList.length);
    }else{
      showToast('Image not selected');
    }
  }
}
