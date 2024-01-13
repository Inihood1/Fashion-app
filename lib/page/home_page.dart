
import 'package:ecommerce/page/tabs/products_page.dart';
import 'package:ecommerce/page/tabs/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../provider/user_provider.dart';
import '../util/db_fields.dart';
import '../util/my_colors.dart';
import '../util/my_text.dart';
import '../util/navigation_service.dart';


class Home extends StatefulWidget {

  const Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  late NavigationService _navigation;
  TabController? _tabController;
  ScrollController? _scrollController;
 // FirebaseAuth auth = FirebaseAuth.instance;
  int index = 0;

  @override
  void initState() {
    _navigation = GetIt.instance.get<NavigationService>();
    _tabController = TabController(length: 2, vsync: this, initialIndex: index);
    _scrollController = ScrollController();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController!.dispose();
    _tabController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    return LoadingOverlay(
      isLoading: false,
      child: WillPopScope(
        onWillPop: () async {
          if(_tabController!.index == 0){
            return true;
          }else{
            _tabController!.animateTo(0);
            return false;
          }
        },
        child: Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScroller){
              return [
                SliverAppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark
                  ),
                  pinned: true,
                  title: const Text(DbFields.appName, style: TextStyle(color: Colors.white),),
                  floating: true,
                  backgroundColor: Colors.deepPurple,
                  forceElevated: innerBoxIsScroller,
                  iconTheme: const IconThemeData(color: MyColors.grey_80),
                  actions: [
                    IconButton(
                        onPressed: (){
                         // _navigation.navigateToPage(const Search());
                        },
                        icon: const Hero(
                            tag: 'search',
                            child: Icon(Icons.search, color: Colors.white,))
                    ),
                  ],
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: false,
                    indicatorPadding: const EdgeInsets.all(10),
                    labelColor: Colors.deepPurple,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    tabs: const [
                      SizedBox(width: 70, child: Tab(text: "Product" ),),
                      SizedBox(width: 70, child: Tab(text: "Profile"),),
                    ],
                    controller: _tabController,
                  ),
                )
              ];
            },
            body:TabBarView(
              controller: _tabController,
              children: const [
               ProductPage(),
                ProfilePage()
              ],
            ),
          ),
        ),
      ),
    );
  }
}


