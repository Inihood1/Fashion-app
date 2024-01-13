
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(height: 50, width: 50, color: Colors.grey[300],),
                Container(width: 20),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 10, width : 80, color: Colors.grey[300]),
                    Container(height: 10),
                    Container(height: 10, width : 80, color: Colors.grey[300]),
                    Container(height: 10),
                    Container(height: 10, width : 40, color: Colors.grey[300])
                  ],
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
