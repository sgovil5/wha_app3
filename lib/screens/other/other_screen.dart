import 'package:flutter/material.dart';
import '../other/about_us_swiper.dart';

class OtherScreen extends StatelessWidget {
  void selectOtherPage(BuildContext context, String page) {
    var pushPage;
    if (page == "About Us") {
      pushPage = AboutUsSwiper.routeName;
    }
    Navigator.of(context)
        .pushNamed(
      pushPage,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  Widget buildSection(BuildContext context, String text, String page) {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          height: 0,
        ),
        InkWell(
          onTap: () => selectOtherPage(context, page),
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 300,
            width: double.infinity,
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                  "https://www.wholistichealthalliance.org/images/logo.png"),
            ),
          ),
          buildSection(context, "About Wholistic Health Alliance", "About Us"),
          buildSection(context, "Terms of Use and Service", "Terms"),
          Divider(
            thickness: 2,
            color: Colors.white,
            height: 0,
          ),
        ],
      ),
    );
  }
}
