import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    return Scaffold(
      body: Text("Helo")
    );
  }
}
