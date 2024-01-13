import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/page/product_details_screen.dart';
import 'package:ecommerce/widget/error.dart';
import 'package:ecommerce/widget/loading.dart';
import 'package:ecommerce/widget/single_item.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/product.dart';
import '../../provider/user_provider.dart';
import '../../util/my_colors.dart';
import '../../util/my_text.dart';
import '../../util/navigation_service.dart';
import '../../widget/star_rating.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with AutomaticKeepAliveClientMixin<ProductPage>{

  @override
  bool get wantKeepAlive => true;

  late NavigationService _navigation;


  @override
  void initState() {
    _navigation = GetIt.instance.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    return Scaffold(
        backgroundColor: MyColors.grey_10,
      body: FutureBuilder<List<dynamic>>(
        future: provider.fetchProducts(), // async work
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return const Center(child: Loading());
            default:
              if (snapshot.hasError) {
                return ErrorNoDataWidget(onClick: (value) {
                  provider.fetchProducts();
                  setState(() {});
                },);
              } else {
                return
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification){
                      if(scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent){
                        // PAGINATE DATA HERE
                      }
                      return true;
                    },
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                     // shrinkWrap: true,
                      padding: const EdgeInsets.all(4),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                         List<ProductModel> dataList = [];
                        for (var doc in snapshot.data!.toSet().toList()) {
                          dataList.add(ProductModel.fromJson(doc));
                        }
                        ProductModel productModelList = dataList[index];
                        return FadedSlideAnimation(
                          beginOffset: const Offset(0, 0.3),
                          endOffset: const Offset(0, 0),
                          slideDuration: const Duration(seconds: 1),
                          slideCurve: Curves.bounceIn,
                          child: SingleItemTile(
                            productModel: productModelList,
                            onTap: (ProductModel value) {
                            _navigation.navigateToPage(ProductDetailsScreen(productModel: value,));
                          },),
                        );
                      }
                                    ),
                  );
              }
          }
        },
      ),
    );
  }
}

