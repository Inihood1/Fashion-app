import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';


class LocalStorage{

  Future<void> setProfileData(Map<String, dynamic> data) async {
    var token = {};
    var profileBox = await Hive.openBox("box");
    profileBox.put("box", token);
  }

  //
  // Future<UserModel> getProfileData() async {
  //   UserModel user =  UserModel();
  //   var profileBox = await Hive.openBox(Strings.profile);
  //   var profileToken = await Hive.openBox(Strings.token);
  //   final profileData = profileBox.get(Strings.data);
  //   final token = profileToken.get(Strings.token);
  //   user.email = profileData["email"];
  //   user.id = profileData["id"];
  //   user.mobile = profileData["mobile"];
  //   user.shopLong = profileData["shopLong"] ?? "null";
  //   user.shopLat = profileData["shopLat"];
  //   user.name = profileData["name"];
  //   user.storeName = profileData["storeName"];
  //   user.coverImage = profileData["coverImage"];
  //   user.regDate = profileData["regDate"];
  //   user.enabled = profileData["enabled"];
  //   user.token = token;
  //   return user;
  // }
  //
  // Future<void> clearData() async {
  //   var profileBox = await Hive.openBox(Strings.profile);
  //   await profileBox.clear();
  // }
}