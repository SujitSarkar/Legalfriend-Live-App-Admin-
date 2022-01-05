import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({Key? key,this.imageList}) : super(key: key);
  final List<dynamic>? imageList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  PhotoViewGallery.builder(
          itemCount: imageList!.length,
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(imageList![index]),
              initialScale: PhotoViewComputedScale.contained * 1,
              heroAttributes: PhotoViewHeroAttributes(tag: imageList![index]),
            );
          },
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded/event.expectedTotalBytes!,
              ),
            ),
          ),
        )
      ),
    );
  }
}
