import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laiv/controllers/auth_controller.dart';
import 'package:laiv/controllers/streaming_controller.dart';
import 'package:laiv/models/streaming.dart';
import 'package:laiv/models/users.dart';
import 'package:laiv/screens/pages/audience_page.dart';
import 'package:laiv/screens/widgets/post_card.dart';
import 'package:laiv/screens/widgets/profile_box.dart';
import 'package:laiv/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FeedsPage extends StatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  AuthController _authController = AuthController();
  StreamingController _streamingController = StreamingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIVE"),
        backgroundColor: AppColors.blackColor,
      ),
      backgroundColor: AppColors.blackColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FutureBuilder(
                      future: _authController.getUserDetail(),
                      builder: (contex, AsyncSnapshot<Users> snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              ProfileBox(
                                name: snapshot.data.name,
                                userPhoto: snapshot.data.profilePhoto,
                                borderWidth: 3,
                                borderColor: AppColors.lightBlueColor,
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.only(
                                    top: 16, bottom: 5, left: 16),
                                child: Icon(
                                  Icons.add_circle,
                                  color: AppColors.onlineDotColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    StreamBuilder(
                      stream: _authController.getFollowing(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          height: 138,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                stream: _authController.getUserFollowing(
                                    snapshot.data.docs[index].id),
                                builder: (contex,
                                    AsyncSnapshot<DocumentSnapshot> users) {
                                  if (users.data != null) {
                                    print(users.data.data());
                                    Users user =
                                        Users.fromMap(users.data.data());
                                    return Stack(
                                      children: [
                                        ProfileBox(
                                          name: user.name,
                                          userPhoto: user.profilePhoto,
                                          borderWidth: 3,
                                          borderColor: AppColors.lightBlueColor,
                                        ),
                                        user.isLive
                                            ? StreamBuilder(
                                                stream: _streamingController
                                                    .streamingStream(
                                                        uid: user.uid),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snap) {
                                                  if (snap.data != null) {
                                                    Streaming streaming =
                                                        Streaming.fromMap(
                                                            snap.data.data());
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (contex) =>
                                                                AudiencePage(
                                                              channelId:
                                                                  streaming
                                                                      .chanelId,
                                                              title: streaming
                                                                  .title,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        height: 80,
                                                        width: 80,
                                                        margin: EdgeInsets.only(
                                                            top: 16,
                                                            bottom: 5,
                                                            left: 16),
                                                        child: Text(
                                                          " LIVE ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                })
                                            : Container(),
                                      ],
                                    );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              PostCard(),
              PostCard(),
            ],
          ),
        ),
      ),
    );
  }
}
