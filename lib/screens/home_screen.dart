import 'package:laiv/screens/pages/add_live_stream.dart';
import 'package:laiv/screens/pages/feeds_page.dart';
import 'package:laiv/screens/pages/profile_page.dart';
import 'package:laiv/screens/search_screen.dart';
import 'package:laiv/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    setState(() {
      pageController.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: PageView(
        children: [
          Center(
            child: FeedsPage(),
          ),
          Center(
            child: SearchScreen(),
          ),
          Center(
            child: AddLiveStream(),
          ),
          Center(
            child: Text("Favorit"),
          ),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: CupertinoTabBar(
          activeColor: AppColors.blueColor,
          backgroundColor: AppColors.blackColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  size: 35,
                  color: (_page == 0)
                      ? AppColors.lightBlueColor
                      : AppColors.greyColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  size: 35,
                  color: (_page == 1)
                      ? AppColors.lightBlueColor
                      : AppColors.greyColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call_outlined,
                  size: 35,
                  color: (_page == 2)
                      ? AppColors.lightBlueColor
                      : AppColors.greyColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined,
                  size: 35,
                  color: (_page == 3)
                      ? AppColors.lightBlueColor
                      : AppColors.greyColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline,
                  size: 35,
                  color: (_page == 4)
                      ? AppColors.lightBlueColor
                      : AppColors.greyColor),
            )
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
