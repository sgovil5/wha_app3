import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

class AboutUsSwiper extends StatelessWidget {
  static const routeName = '/about-us-swiper';

  Widget buildSwiperPage(String title, String bodyText) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 50,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/whalogo.png"),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 0, 30, 50),
            child: Text(
              bodyText,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  final Map<String, String> map = {
    "What is WHA":
        "Wholistic Health Alliance is a nationally launched 501c3, non-profit organization with the vision of building healthy communities as well as providing a platform for holistic health practitioners to come together under one umbrella, fostering collaborations, building stronger networks and enabling greater synergy with the community. WHA provides a robust Directory to assist your search for a holistic practitioner of your choice effectively, in your own geographical area. We currently operate in the states of Massachusetts and Colorado, and are actively looking to expand into other states.",
    "Our mission":
        '''Our mission is simple - to build healthier communities through education and dissemination of information about simple tools for prevention and holistic solutions for health and wellness, through free, year-round events, publication of articles, and more. This not only benefits and empowers the community, it also gives exposure and visibility to the holistic practitioners who deliver the talks and write the articles. WHA also strives to bring the holistic practitioner community together for networking, enhanced inter-disciplinary collaborations, and for simply learning more about other holistic modalities and their respective approaches to health and wellness. In addition to our year-round talks and events, we hold practitioner meetings and fun get-togethers to build a strong, well-connected body of holistic professionals.''',
    "The Youth Brigade And This App":
        "We are a team of high schoolers who helped in the development of the app. We come from many different states and spent months into making this app. There were 3 teams that were formed to make this app: Research, Wireframing, and Coding."
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        loop: false,
        itemBuilder: (ctx, index) {
          return buildSwiperPage(
            map.keys.toList()[index],
            map.values.toList()[index],
          );
        },
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: Colors.white,
            activeColor: Colors.blue,
          ),
        ),
        itemCount: map.length,
        control: SwiperControl(),
      ),
    );
  }
}
