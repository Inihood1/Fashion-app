import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/page/auth/login.dart';
import 'package:ecommerce/page/auth/register.dart';
import 'package:ecommerce/page/home_page.dart';
import 'package:ecommerce/page/waiting_page.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/util/db_fields.dart';
import 'package:ecommerce/util/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';


CollectionReference users = FirebaseFirestore.instance.collection(DbFields.users);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  runApp(MyApp(prefs: prefs,));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp( {super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final textThem = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(context, prefs)),
        //ChangeNotifierProvider(create: (_) => Service(context)),
      ],
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          theme: ThemeData(
            textTheme: GoogleFonts.abelTextTheme(textThem),
            primarySwatch: Colors.deepPurple,
            primaryColor: Colors.purple,
          ),
          initialRoute: '/login',
          routes: {
             '/reg': (BuildContext context) => const RegisterPage(),
             '/home': (BuildContext context) =>  const Home(),
            '/wait': (BuildContext context) =>  const WaitingPage(),
             '/login': (BuildContext context) =>  const LoginPage(),
          },
        ),
      ),
    );
  }
}

