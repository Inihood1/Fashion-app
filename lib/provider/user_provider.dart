import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/user.dart';
import '../service/service.dart';
import '../storage/local_storage.dart';
import '../util/navigation_service.dart';
import '../util/utils.dart';


class UserProvider with ChangeNotifier{

  late LocalStorage localStorage;
  late Services services;
  late NavigationService _navigation;
  BuildContext context;
  bool isLoading = false;
  bool isProfileLoading = false;
  late SharedPreferences prefs;
  FirebaseAuth auth = FirebaseAuth.instance;
  late CurrentUser user;

    UserProvider(this.context, this.prefs){
    localStorage = LocalStorage();
    services = Services();
    _navigation = GetIt.instance.get<NavigationService>();
    detectAuthChange();
  }

  Future<void> getUserData() async {
    isProfileLoading = true;
      var document = await users.doc(auth.currentUser?.uid).get();
    if(document.exists){
    user =  CurrentUser.fromDocument(document);
    isProfileLoading = false;
    notifyListeners();
    }else{
      isProfileLoading = false;
      notifyListeners();
      logout();
      if(context.mounted){
        Utils.showMessage("Something went wrong", context);
      }
      if (_navigation.getCurrentRoute() != '/login') {
        _navigation.removeAndNavigateToRoute('/login');
      }
    }


  }

  Future<void> saveData(String name, String imageUrl) async {
    isProfileLoading = true;
    notifyListeners();
    await users.doc(auth.currentUser?.uid).update({"name": name, "pic": imageUrl,});
    isProfileLoading = false;
    notifyListeners();
    getUserData();
  }

  Future<void> detectAuthChange() async {
      //auth.signOut();
    auth.authStateChanges().listen((userAuth) async {
      if (userAuth != null) {
        getUserData();
        _navigation.removeAndNavigateToRoute('/home');
      }else{
        if (_navigation.getCurrentRoute() != '/login') {
          _navigation.removeAndNavigateToRoute('/login');
        }
      }

    });
  }

  Future<List<dynamic>> fetchProducts()  async {
    return await services.getProducts();
  }

  void logout(){
    auth.signOut();
    notifyListeners();
  }

}