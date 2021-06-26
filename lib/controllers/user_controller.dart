import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laiv/constants/string.dart';
import 'package:laiv/models/users.dart';

class USerController {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference streamingCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  Future<Users> getUserDetail(String userId) async {}
}
