import 'package:laiv/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class PostCard extends StatefulWidget {
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.separatorColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                        "https://lh3.googleusercontent.com/a-/AOh14Gj-UtcAypos7FB73l30BPYkBglHxRzVbii4ztrf0A=s96-c"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("@username"),
                      Text(
                        "5 minutes ago",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.more_outlined),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  "https://i.pinimg.com/originals/11/1a/03/111a03133d14214539c96e0f657dff1a.png",
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xff8f8f8f).withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    alignment: Alignment.bottomCenter,
                    child: Text("Ini Judulnya"),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked ? isLiked = false : isLiked = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 5),
                              child: Icon(
                                Icons.favorite,
                                size: 30,
                                color: isLiked ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Text("100"),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 5),
                            child: Icon(
                              Icons.chat_bubble_outlined,
                              size: 30,
                            ),
                          ),
                          Container(
                            child: Text("100"),
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.repeat,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ReadMoreText(
                    "Optimisme adalah kepercayaan yang mengarah pada pencapaian. Tidak ada yang bisa dilakukan tanpa harapan dan keyakinan - Helen Keller.",
                    trimLines: 2,
                    colorClickableText: AppColors.greyColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: "More",
                    trimExpandedText: "Less",
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
