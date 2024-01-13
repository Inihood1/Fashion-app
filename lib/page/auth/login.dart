import 'package:ecommerce/page/auth/register.dart';
import 'package:ecommerce/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../../util/my_colors.dart';
import '../../util/my_text.dart';
import '../../util/navigation_service.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}


class LoginPageState extends State<LoginPage> {

  late NavigationService _navigation;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _navigation = GetIt.instance.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
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
            Image.asset("assets/img7.jpg",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                            controller: emailController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
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
                          child: TextField(
                            maxLines: 1,
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
                        Material(
                          color: Colors.deepPurple[500],
                          child: InkWell(
                              highlightColor: Colors.black.withOpacity(0.2),
                              splashColor: Colors.black.withOpacity(0.2),
                              onTap: () {
                                login();
                              },
                              child: Container( height: 50, alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: Text("Login", style: MyText.body2(context)!.copyWith(color: Colors.white)),
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
                        Text("Dont have an account? ", style: MyText.subhead(context)!.copyWith(color: MyColors.grey_20)),
                        TextButton(onPressed: (){
                          _navigation.navigateToPage(RegisterPage());
                        }, child: Text("Register here"))
                      ],
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  void login(){
    if(emailController.text.isNotEmpty && emailController.text.contains("@")){
      if(passController.text.isNotEmpty){
        setState(() {
          isLoading = true;
        });
       auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text).then((value) {
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

