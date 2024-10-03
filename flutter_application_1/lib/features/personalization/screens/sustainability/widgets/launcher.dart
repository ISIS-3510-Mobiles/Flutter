import 'package:url_launcher/url_launcher.dart';

launchURL() async {
  const url = 'https://www.youtube.com/watch?v=F6R_WTDdx7I';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}