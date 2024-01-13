import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../../util/my_colors.dart';
import '../../util/my_text.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage> {

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    return LoadingOverlay(
      isLoading: provider.isProfileLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(height: 35),
                Text(provider.user.name, style: MyText.headline(context)!.copyWith(
                    color: Colors.grey[900], fontWeight: FontWeight.bold
                )),
                Container(height: 5),
                Text(provider.user.email, textAlign : TextAlign.center, style: MyText.subhead(context)!.copyWith(
                    color: Colors.grey[600]
                )),
                Container(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: 60, height: 60,
                        child: Icon(Icons.edit, color: Colors.lightGreen[600]),
                      ),
                      onTap: (){
                        _displayTextInputDialog(context, provider);
                      },
                    ),
                    Container(width: 10),
                    CircleAvatar(
                      radius: 62,
                      backgroundColor: Colors.purple[600],
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: CachedNetworkImageProvider(provider.user.pic),
                      ),
                    ),
                    Container(width: 10),
                    InkWell(
                      child: Container(
                        width: 60, height: 60,
                        child: Icon(Icons.camera_alt, color: Colors.lightGreen[600]),
                      ),
                      onTap: () async {
                        XFile? file  = await provider.services.pickImage();
                        Utils.showMessage("This wont take long", context);
                        String url = await provider.services.uploadImage(file!);
                        provider.saveData(provider.user.name, url);
                      },
                    ),
                  ],
                ),
                Divider(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Text(provider.user.faves_item_id.length.toString(), style: MyText.title(context)!.copyWith(
                              color: Colors.purple[600], fontWeight: FontWeight.bold
                          )),
                          Container(height: 5),
                          Text("Favourites", style: MyText.medium(context).copyWith(color: Colors.grey[500])),
                          TextButton(onPressed: (){
                            provider.logout();
                          }, child: Text("Logout", style: MyText.title(context),))
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 50),


              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> _displayTextInputDialog(BuildContext context, UserProvider provider) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change name'),
          content: TextField(

            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Input your name here"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                if(_textFieldController.text != provider.user.name){
                  provider.saveData(_textFieldController.text, provider.user.pic);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

