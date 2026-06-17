import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  Future<bool> open(String url) {
    return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
