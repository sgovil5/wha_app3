import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../other/about_us_swiper.dart';

class OtherScreen extends StatelessWidget {
  void selectAboutUs(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      AboutUsSwiper.routeName,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  Widget buildSection(BuildContext context, String text, Function action) {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          height: 0,
        ),
        InkWell(
          onTap: () => action(context),
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
              backgroundImage: AssetImage("assets/whalogo.png"),
            ),
          ),
          buildSection(
              context, "About Wholistic Health Alliance", selectAboutUs),
          buildSection(context, "Terms of Use and Service", null),
          buildSection(context, "Logout", logout),
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
