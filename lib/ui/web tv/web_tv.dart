import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/home.dart';
import 'package:investtech_app/network/models/web_tv.dart';
import 'package:investtech_app/ui/web%20tv/web_tv_list_page.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import 'package:investtech_app/ui/web%20tv/web_tv_item.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebTVList()),
              );
            },
            child: ProductHeader(webTvTeaser.title, 1),
          ),
          WebTVItem(videoContent: videoContent.video)
        ],
      ),
    );
  }
}
