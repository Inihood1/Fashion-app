import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_colors.dart';
import 'my_text.dart';

class Utils{

  static void showMessage(String message, BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void showSnack(BuildContext context, ProductModel productModel, {required final ValueChanged onTap}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      content: Card(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
        clipBehavior: Clip.antiAliasWithSaveLayer, elevation: 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Container(width: 5, height: 0),
              CachedNetworkImage(imageUrl: productModel.image!, height: 40, width: 40,),
              Container(width: 10, height: 0),
              Expanded(child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(productModel.title!, style: MyText.subhead(context)!.copyWith(color: MyColors.grey_90)),
                  Text("Added to Favourite", style: MyText.caption(context)!.copyWith(color: MyColors.grey_40)),
                ],
              )),
              Container(color: MyColors.grey_20, height: 35, width: 1, margin: EdgeInsets.symmetric(horizontal: 5)),
              SnackBarAction(
                label: "UNDO", textColor: MyColors.primary,
                onPressed: () => onTap(null),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: 3),
    ));
  }
}