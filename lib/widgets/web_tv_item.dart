import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/network/models/web_tv.dart';
import 'package:investtech_app/ui/web_tv_youTube_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebTVItem extends StatelessWidget {
  final Video videoContent;
  const WebTVItem({
    Key? key,
    required this.videoContent,
  }) : super(key: key);

  void _launchUrl(url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    var descirption = [];

    if (videoContent.description.contains('https')) {
      descirption = videoContent.description.split("https");
      descirption[1] = 'https${descirption[1]}';
    } else if (videoContent.description.contains('www')) {
      descirption = videoContent.description.split("www");
      descirption[1] = 'www${descirption[1]}';
    } else {}

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewYouTube(
                        AppLocalizations.of(context)!.web_tv,
                        'https://www.youtube.com/watch?v=${videoContent.youtubeId}')),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://img.youtube.com/vi/${videoContent.youtubeId}/0.jpg'),
                          fit: BoxFit.fitWidth)),
                ),
                Container(
                  width: 45,
                  height: 30,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              videoContent.title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          descirption.length > 1
              ? RichText(
                  text: TextSpan(
                      text: descirption[0],
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: descirption[1],
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                var url = descirption[1];
                                if (!descirption[1]
                                    .toString()
                                    .contains('https')) {
                                  url = 'https://${descirption[1]}';
                                }
                                _launchUrl(Uri.parse(url));
                              },
                            style: const TextStyle(
                              color: Color(ColorHex.teal),
                              decoration: TextDecoration.underline,
                            ))
                      ]),
                )
              : Text(
                  videoContent.description,
                  style: const TextStyle(fontSize: 10),
                ),
        ],
      ),
    );
  }
}
