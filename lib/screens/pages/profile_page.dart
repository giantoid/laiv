import 'package:laiv/controllers/auth_controller.dart';
import 'package:laiv/models/users.dart';
import 'package:laiv/screens/login_screen.dart';
import 'package:laiv/screens/widgets/playlist.dart';
import 'package:laiv/screens/widgets/posts.dart';
import 'package:laiv/screens/widgets/profile_box.dart';
import 'package:laiv/screens/widgets/schedule.dart';
import 'package:laiv/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int active = 0;
  AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(children: [
        FutureBuilder(
            future: _authController.getUserDetail(),
            builder: (context, AsyncSnapshot<Users> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 60, bottom: 15),
                      alignment: Alignment.center,
                      child: ProfileBox(
                        name: snapshot.data.name,
                        userPhoto: snapshot.data.profilePhoto,
                        nameSize: 20,
                        nameWeight: FontWeight.bold,
                        profesion: snapshot.data.profession,
                        boxHeight: 95,
                        boxWidth: 95,
                      ),
                    ),
                    Container(
                      child: Text(snapshot.data.bio),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: FutureBuilder(
                          future: _authController.getFollow(snapshot.data.uid),
                          builder: (context, AsyncSnapshot<Users> snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data.followers.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Followers"),
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: AppColors.blueColor,
                                    width: 40,
                                    thickness: 5,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data.following.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Following"),
                                    ],
                                  )
                                ],
                              );
                            }
                            return Container();
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: active == 0
                                  ? AppColors.lightBlueColor
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.videocam,
                              color: active == 0
                                  ? AppColors.lightBlueColor
                                  : Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                active = 0;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: active == 1
                                  ? AppColors.lightBlueColor
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.list,
                              color: active == 1
                                  ? AppColors.lightBlueColor
                                  : Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                active = 1;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: active == 2
                                  ? AppColors.lightBlueColor
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.watch_later_outlined,
                              color: active == 2
                                  ? AppColors.lightBlueColor
                                  : Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                active = 2;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    active == 0 ? Posts() : Container(),
                    active == 1 ? PlayList() : Container(),
                    active == 2 ? Schedule() : Container(),
                  ],
                );
              }
              return Container(
                width: screenSize.width,
                height: screenSize.height,
                child: Center(child: CircularProgressIndicator()),
              );
            }),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, right: 10),
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                child: Icon(Icons.more_horiz),
                onSelected: (result) {
                  if (result == "logout") {
                    _authController.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: "logout",
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25, right: 10),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.person_add,
                size: 30,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25, right: 10),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.send,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
