
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../util/my_colors.dart';
import '../util/my_text.dart';

class ErrorNoDataWidget extends StatelessWidget {
  final ValueChanged onClick;

  const ErrorNoDataWidget({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center, width: 280,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(MdiIcons.networkOff),
                Text("Whoops!", style: MyText.display1(context)!.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold
                )),
                Container(height: 10),
                Text("No internet connections found. Check your connection or try again",
                    textAlign: TextAlign.center, style: MyText.medium(context).copyWith(color: Colors.black)
                ),
                Container(height: 25),
                Container(
                  width: 180, height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    child: Text("RETRY", style: TextStyle(color: Colors.white)),
                    onPressed: () => onClick(null),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
