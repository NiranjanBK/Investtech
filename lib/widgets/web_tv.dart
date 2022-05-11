import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/home.dart';
import 'package:investtech_app/network/models/web_tv.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';

class WebTVTeaser extends StatelessWidget {
  final Teaser webTvTeaser;
  const WebTVTeaser(this.webTvTeaser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebTv videoContent = WebTv.fromJson(webTvTeaser.content);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => Top20ListPage(
              //           jsonDecode(jsonEncode(_top20Data))['title'])),
              // );
            },
            child: ProductHeader(webTvTeaser.title, 1),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  videoContent.video.title,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  videoContent.video.description,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
