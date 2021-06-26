import 'package:laiv/controllers/auth_controller.dart';
import 'package:laiv/models/users.dart';
import 'package:laiv/screens/pages/user_profile_page.dart';
import 'package:laiv/screens/widgets/custom_tile.dart';
import 'package:laiv/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthController _authController = AuthController();

  List<Users> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _authController.getCurrentUser().then((User user) {
      _authController.fetchAllUsers(user).then((List<Users> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      // backgroundColorStart: AppColors.gradientColorstart,
      // backgroundColorEnd: AppColors.gradientColorEnd,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: AppColors.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSugestions(String query) {
    final List<Users> sugestionList = query.isEmpty
        ? []
        : userList.where((Users user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);
          }
            // (User user) =>
            //     (user.username.toLowerCase().contains(query.toLowerCase()) ||
            //         user.name.toLowerCase().contains(query.toLowerCase())),
            ).toList();

    return ListView.builder(
        itemCount: sugestionList.length,
        itemBuilder: (context, index) {
          Users searchUser = Users(
            uid: sugestionList[index].uid,
            profilePhoto: sugestionList[index].profilePhoto,
            name: sugestionList[index].name,
            username: sugestionList[index].username,
          );
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                    uid: searchUser.uid,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(searchUser.profilePhoto),
            ),
            title: Text(
              searchUser.username,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              searchUser.name,
              style: TextStyle(color: AppColors.greyColor),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSugestions(query),
      ),
    );
  }
}
