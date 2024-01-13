
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';

class PhotoViewer extends StatelessWidget {
  final String url;
  final String title;
  const PhotoViewer({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white,)),
        title: Text(title, style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Hero(
        tag: url,
        child: PhotoView(
         // imageProvider: AssetImage(url,)
          imageProvider: CachedNetworkImageProvider(url, )
        ),
      )
    );
  }

}
