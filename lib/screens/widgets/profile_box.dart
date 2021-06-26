import 'package:laiv/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileBox extends StatelessWidget {
  final String name;
  final String userPhoto;
  final double nameSize;
  final FontWeight nameWeight;
  final double borderWidth;
  final Color borderColor;
  final String profesion;
  final double boxWidth;
  final double boxHeight;

  const ProfileBox({
    Key key,
    @required this.name,
    @required this.userPhoto,
    this.nameSize,
    this.profesion = "",
    this.borderWidth = 0,
    this.borderColor,
    this.boxHeight = 70,
    this.boxWidth = 70,
    this.nameWeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: boxHeight,
          width: boxWidth,
          padding: EdgeInsets.all(2.5),
          margin: EdgeInsets.only(top: 16, bottom: 5, left: 16),
          decoration: BoxDecoration(
            border:
                Border.all(width: borderWidth, color: AppColors.lightBlueColor),
            borderRadius: BorderRadius.circular(boxWidth / 2.5),
          ),
          child: userPhoto != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(boxWidth / 2.8),
                  child: Image.network(userPhoto),
                )
              : null,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 5, left: 16),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(fontSize: nameSize, fontWeight: nameWeight),
              ),
              Text(profesion),
            ],
          ),
        )
      ],
    );
  }
}
