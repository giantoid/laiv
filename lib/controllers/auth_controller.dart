import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laiv/constants/string.dart';
import 'package:laiv/enum/user_state.dart';
import 'package:laiv/models/users.dart';
import 'package:laiv/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection =
      firestore.collection(USERS_COLLECTION);

  //user class
  Users user = Users();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<Users> getUserDetail() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();

    return Users.fromMap(documentSnapshot.data());
  }

  Future<Users> getFollow(String uid) async {
    QuerySnapshot followers =
        await _userCollection.doc(uid).collection("followers").get();
    QuerySnapshot following =
        await _userCollection.doc(uid).collection("following").get();

    return Users.fromFollowMap({
      "followers": followers.docs.length,
      "following": following.docs.length,
    });
  }

  Stream<QuerySnapshot> getFollowing() {
    User currentUser = _auth.currentUser;
    return _userCollection
        .doc(currentUser.uid)
        .collection("following")
        .snapshots();
  }

  // Future<Users> getUserFollowing(String uid) async {
  //   DocumentSnapshot snapshot = await _userCollection.doc(uid).get();

  //   return Users.fromMap(snapshot.data());
  // }

  Stream<DocumentSnapshot> getUserFollowing(String uid) =>
      _userCollection.doc(uid).snapshots();

  Future<Users> getUserDetailById(String uid) async {
    print(uid);
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(uid).get();
      return Users.fromMap(documentSnapshot.data());
    } catch (e) {
      print("ini error" + e);
      return null;
    }
  }

  Future<UserCredential> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    UserCredential user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(UserCredential user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential currentUser) async {
    var users = currentUser.user;
    String username = Utils.getUsername(users.email);

    user = Users(
        uid: users.uid,
        email: users.email,
        name: users.displayName,
        profilePhoto: users.photoURL,
        username: username);

    firestore.collection(USERS_COLLECTION).doc(users.uid).set(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<Users>> fetchAllUsers(User currentUser) async {
    List<Users> userList = List<Users>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(Users.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) {
    return _userCollection.doc(uid).snapshots();
  }

  Future<void> follow(String uid) async {
    User currentUser = await getCurrentUser();

    Users following = Users(uid: uid);
    Users follower = Users(uid: currentUser.uid);

    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .collection("following")
        .doc(uid)
        .set(user.follow(following));

    firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .collection("followers")
        .doc(currentUser.uid)
        .set(user.follow(follower));

    getFollow(currentUser.uid);
  }

  Future<void> unFollow(String uid) async {
    User currentUser = await getCurrentUser();
    _userCollection
        .doc(currentUser.uid)
        .collection("following")
        .doc(uid)
        .delete();

    _userCollection
        .doc(uid)
        .collection("followers")
        .doc(currentUser.uid)
        .delete();

    getFollow(currentUser.uid);
  }

  Future<bool> checkFollow(String uid) async {
    User currentUser = await getCurrentUser();
    QuerySnapshot snapshot = await _userCollection
        .doc(currentUser.uid)
        .collection("following")
        .where("uid", isEqualTo: uid)
        .get();

    bool hasil;

    if (snapshot.docs.length > 0) {
      hasil = true;
    } else {
      hasil = false;
    }

    return hasil;
  }
}
