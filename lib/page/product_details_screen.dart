import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/page/photo_view.dart';
import 'package:ecommerce/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../provider/user_provider.dart';
import '../util/my_colors.dart';
import '../util/my_text.dart';
import '../util/navigation_service.dart';
import '../widget/star_rating.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailsScreen({super.key, required this.productModel});

  @override
  ProductDetailsScreenState createState() => ProductDetailsScreenState();
}


class ProductDetailsScreenState extends State<ProductDetailsScreen> {

  int page = 0;
  late NavigationService _navigation;
  static const int MAX = 5;
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
      isLoading: provider.isProfileLoading,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0)),
                elevation: 2,
                margin: EdgeInsets.all(0),
                child: Container(
                  height: 250,
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          _navigation.navigateToPage(PhotoViewer(url: widget.productModel.image!,
                              title: widget.productModel.title!));
                        },
                        child: Hero(
                          tag: widget.productModel.image!,
                          child: PageView(
                            onPageChanged: onPageViewChange,
                            children: <Widget>[
                              CachedNetworkImage(imageUrl: widget.productModel.image!, fit: BoxFit.cover,),
                              CachedNetworkImage(imageUrl: widget.productModel.image!, fit: BoxFit.cover,),
                              CachedNetworkImage(imageUrl: widget.productModel.image!, fit: BoxFit.cover,),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.5)])
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: buildDots(context),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0)),
                elevation: 2,
                margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: "${widget.productModel.title!}Ac566cc",
                          child: Text(widget.productModel.title!, style: MyText.headline(context)!.copyWith(color: Colors.grey[900]))),
                      Container(height: 5),
                      Text(widget.productModel.category!, style: MyText.subhead(context)!.copyWith(color: Colors.grey[600])),
                      Container(height: 20),
                      Row(
                        children: <Widget>[
                          StarRating(starCount: 5, rating: double.parse("${widget.productModel.rating?['rate']}"), color: Colors.deepPurple, size: 18),
                          Container(width: 5),
                          Text("${widget.productModel.rating?['count']}", style: MyText.caption(context)!.copyWith(color: Colors.grey[400])),
                          Spacer(),
                          Text("\$ ${widget.productModel.price}", style: MyText.headline(context)!.copyWith(
                              color: Colors.lightGreen[700], fontWeight: FontWeight.bold
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0)),
                elevation: 2,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Description", style: MyText.headline(context)!.copyWith(color: Colors.grey[900])),
                      Container(height: 5),
                      Text(widget.productModel.description!, textAlign: TextAlign.justify,
                          style: MyText.subhead(context)!.copyWith(color: Colors.grey[600])
                      ),
                      Container(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: provider.isProfileLoading ? SizedBox.shrink() : FloatingActionButton.extended(
            onPressed: (){
              /// TODO: improve list to use SET to avoid duplicates instead of list
              if(provider.user.faves_item_id.contains(widget.productModel.id)){
                  // remove from fav
                users.doc(auth.currentUser!.uid).update({"faves_item_id":FieldValue.arrayRemove([widget.productModel.id])});
                provider.getUserData();
                setState(() {});
              }else{
                // add to fave
                Utils.showMessage("Adding...", context);
                users.doc(auth.currentUser!.uid).update({"faves_item_id":
                FieldValue.arrayUnion([widget.productModel.id])
                }).then((value) {
                  provider.getUserData();
                  setState(() {});
                  Utils.showSnack(context, widget.productModel, onTap: (t){
                    users.doc(auth.currentUser!.uid).update({"faves_item_id":FieldValue.arrayRemove([widget.productModel.id])});
                    provider.getUserData();
                    setState(() {});
                  });
                } );
                provider.getUserData();
              }

            },
            label: Text(provider.user.faves_item_id.contains(widget.productModel.id) ? "Remove from favourite" : "Add to favourite")),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    setState(() {});
  }

  Widget buildDots(BuildContext context){
    Widget widget;

    List<Widget> dots = [];
    for(int i=0; i<MAX; i++){
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor: page == i ? Colors.blue : Colors.grey[100],
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}

