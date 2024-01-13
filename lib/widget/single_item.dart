
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/widget/star_rating.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../util/my_colors.dart';
import '../util/my_text.dart';

class SingleItemTile extends StatelessWidget {
  final ValueChanged<ProductModel> onTap;
  final ProductModel productModel;

  const SingleItemTile({
    Key? key,
    required this.onTap,
    required this.productModel,
  })  : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(productModel),
      child: Container(
        height: 350,
        padding: EdgeInsets.all(2),
        child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(1),
            elevation: 1,
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                    child: CachedNetworkImage(imageUrl: productModel.image!, fit: BoxFit.cover,)
                ),
                Container(height: 5),
                Row(
                  children: <Widget>[
                    Container(width: 10),
                    Expanded(
                      flex: 1,
                      child: Hero(
                        tag: "${productModel.title!}Ac566cc",
                        child: Text(productModel.title!,
                            style: MyText.subhead(context)!.copyWith(color: MyColors.grey_90), overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(width: 5),
                    const Icon(Icons.more_vert, color: MyColors.grey_40, size: 20),
                  ],
                ),
                Container(height: 5),
                Row(
                  children: <Widget>[
                    Container(width: 10),
                    StarRating(starCount: 5, rating: double.parse("${productModel.rating?['rate']}"), color: Colors.deepPurple, size: 14),
                    const Spacer(),
                    Text("\$${productModel.price}", style: MyText.subhead(context)!.copyWith(color: MyColors.primary, fontWeight: FontWeight.bold)),
                    Container(width: 10),
                  ],
                ),
                Container(height: 10),
              ],
            )
        ),
      ),
    );
  }
}