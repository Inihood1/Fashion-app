import 'dart:convert';
import 'package:ecommerce/util/db_fields.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Services{



  Future<List<dynamic>> getProducts() async {
    var client = http.Client();
    List<dynamic> data = [];
    try {
      final response = await client.get(Uri.parse("${DbFields.baseUrl}/products"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'Authorization': 'Bearer $token',
          },
      );
      if (response.statusCode == 200) {
        data = json.decode(response.body);
      } else {
        data = json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }finally{
      client.close();
    }
    return data;
  }


  Future<String> uploadImage(XFile imageFile) async {
    int name = DateTime.now().microsecondsSinceEpoch;
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("profile/$name.jpg");
    File file_ = File(imageFile.path);
    await mountainsRef.putFile(file_);
    String url = await mountainsRef.getDownloadURL();
    return Future.value(url);
  }


  Future<XFile?> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery,   imageQuality: 80);
  }



}