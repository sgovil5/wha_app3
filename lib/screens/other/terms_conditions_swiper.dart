import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

class TermsConditionsSwiper extends StatelessWidget {
  static const routeName = '/terms-conditions-swiper';

  final Map<String, String> map = {
    "Privacy Policy":
        ''' Protecting your private information is our priority. This Statement of Privacy applies to the www.wholistichealthalliance.org and Wholistic Health Alliance and governs data collection and usage. For the purposes of this Privacy Policy, unless otherwise noted, all references to Wholistic Health Alliance include www.wholistichealthalliance.org and WHA. The WHA website is a Directory Listings, News & Information. Site. By using the WHA website, you consent to the data practices described in this statement.''',
    "Collection of your Personal Information":
        '''WHA may collect personally identifiable information, such as your name. If you purchase WHA's products and services, we collect billing and credit card information. This information is used to complete the purchase transaction. WHA may also collect anonymous demographic information, which is not unique to you, such as your age, gender and Medical Information. We may gather additional personal or non-personal information in the future.
Information about your computer hardware and software may be automatically collected by WHA. This information can include: your IP address, browser type, domain names, access times and referring website addresses. This information is used for the operation of the service, to maintain quality of the service, and to provide general statistics regarding use of the WHA website
Please keep in mind that if you directly disclose personally identifiable information or personally sensitive data through WHA's public message boards, this information may be collected and used by others.
WHA encourages you to review the privacy statements of websites you choose to link to from WHA so that you can understand how those websites collect, use and share your information. WHA is not responsible for the privacy statements or other content on websites outside of the WHA website.
 ''',
    "Use of your Personal Information":
        '''WHA collects and uses your personal information to operate its website(s) and deliver the services you have requested.
WHA may also use your personally identifiable information to inform you of other products or services available from WHA and its affiliates. WHA may also contact you via surveys to conduct research about your opinion of current services or of potential new services that may be offered.
WHA does not sell, rent or lease its customer lists to third parties.
WHA may, from time to time, contact you on behalf of external business partners about a particular offering that may be of interest to you. In those cases, your unique personally identifiable information (e-mail, name, address, telephone number) is not transferred to the third party. WHA may share data with trusted partners to help perform statistical analysis, send you email or postal mail, provide customer support, or arrange for deliveries. All such third parties are prohibited from using your personal information except to provide these services to WHA, and they are required to maintain the confidentiality of your information.

WHA will disclose your personal information, without notice, only if required to do so by law or in the good faith belief that such action is necessary to: (a) conform to the edicts of the law or comply with legal process served on WHA or the site; (b) protect and defend the rights or property of WHA; and, (c) act under exigent circumstances to protect the personal safety of users of WHA, or the public.
''',
    "Security of your Personal Information":
        '''WHA secures your personal information from unauthorized access, use or disclosure.
Children Under Thirteen WHA does not knowingly collect personally identifiable information from children under the age of thirteen. If you are under the age of thirteen, you must ask your parent or guardian for permission to use this website.
Opt-Out & Unsubscribe We respect your privacy and give you an opportunity to opt-out of receiving announcements of certain information. Users may opt-out of receiving any or all communications from WHA by contacting us here:- Email: wholistichealthalliance.group@gmail.com
Changes to this Statement WHA will occasionally update this Statement of Privacy to reflect company and customer feedback. WHA encourages you to periodically review this Statement to be informed of how WHA is protecting your information.
'''
  };

  Widget buildSwiperPage(String title, String bodyText) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            height: 70,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
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
