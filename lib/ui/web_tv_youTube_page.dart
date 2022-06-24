import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class WebViewYouTube extends StatelessWidget {
  final String title;
  final String url;

  const WebViewYouTube(this.title, this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(url),
                method: 'GET',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
            onWebViewCreated: (controller) {
              //_webViewController = controller;
            },
          ),
        ],
      ),
    );
  }
}
