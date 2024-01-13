import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/page/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../util/my_colors.dart';
import '../../util/my_text.dart';
import '../../util/navigation_service.dart';
import '../../util/utils.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}


class RegisterPageState extends State<RegisterPage> {

  late NavigationService _navigation;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    _navigation = GetIt.instance.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: MyColors.grey_10,
        appBar: AppBar(
          backgroundColor: MyColors.grey_40, systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          toolbarHeight: 0, elevation: 0,
        ),
        body: Stack(
          children: [
            Image.asset("assets/img8.jpg",
                width: double.infinity, height: double.infinity,
                fit: BoxFit.cover
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              scrollDirection: Axis.vertical,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Container(height: 25),
                    Text("Fashionista", style: MyText.title(context)?.copyWith(color: Colors.white),),
                    Container(height: 25),
                    Card(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(2),),
                      clipBehavior: Clip.antiAliasWithSaveLayer, elevation: 1, margin: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: TextField(
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12), border: InputBorder.none,
                                  hintText: "Email", hintStyle: MyText.subhead(context)!.copyWith(color: MyColors.grey_40)
                              ),
                            ),
                          ),
                          Divider(height: 0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: TextField(maxLines: 1,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              controller: passController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                                  hintText: "Password", hintStyle: MyText.subhead(context)!.copyWith(color: MyColors.grey_40)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(height: 25),
                    Card(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(2),),
                      clipBehavior: Clip.antiAliasWithSaveLayer, elevation: 1, margin: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: TextField(maxLines: 1,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.name,
                              controller: nameController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                                  hintText: "Full Name", hintStyle: MyText.subhead(context)!.copyWith(color: MyColors.grey_40)
                              ),
                            ),
                          ),

                          Material(
                            color: Colors.deepPurple[500],
                            child: InkWell(
                              highlightColor: Colors.black.withOpacity(0.2),
                              splashColor: Colors.black.withOpacity(0.2),
                              onTap: () {
                                register();
                              },
                              child: Container( height: 50, alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: Text("CREATE ACCOUNT", style: MyText.body2(context)!.copyWith(color: Colors.white)),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(height: 25),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: MyText.subhead(context)!.copyWith(color: MyColors.grey_20)),
                          TextButton(onPressed: (){
                            _navigation.navigateToPage(LoginPage());
                          }, child: Text("Login here"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void register(){
    if(emailController.text.isNotEmpty && emailController.text.contains("@") && nameController.text.isNotEmpty){
      if(passController.text.isNotEmpty){
        setState(() {
          isLoading = true;
        });
        auth.createUserWithEmailAndPassword(email: emailController.text, password: passController.text).then((value) async {
          await users.doc(auth.currentUser!.uid).set({
            "name":nameController.text,
            "email":emailController.text,
            "regDate":Timestamp.now(),
            "faves_item_id":[],
            "pic":"",
          });
          setState(() {
            isLoading = false;
          });
          _navigation.removeAndNavigateToRoute('/home');
        }).onError((error, stackTrace) {
          setState(() {
            isLoading = false;
          });
          Utils.showMessage("Something is not right: ${error.toString()}", context);
        });
      }
    }else{
      Utils.showMessage("Something is not right", context);
    }
  }



}

