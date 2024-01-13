import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String name;
  final String email;
  final String pic;
  final List<dynamic> faves_item_id;
  final Timestamp regDate;

  CurrentUser({
    required this.name,
    required this.email,
    required this.pic,
    required this.regDate,
    required this.faves_item_id,
  });

  factory CurrentUser.fromDocument(DocumentSnapshot doc) {
    return CurrentUser(
      name: doc.get("name"),
      email: doc.get("email"),
      pic: doc.get("pic"),
      faves_item_id: doc.get("faves_item_id"),
      regDate: doc.get("regDate") ?? Timestamp.now(),
    );
  }
}

