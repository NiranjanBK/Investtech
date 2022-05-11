import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPrivacyPage extends StatefulWidget {
  final String title;
  final String url;
  bool isLoading = true;
  WebViewPrivacyPage(this.title, this.url, {Key? key}) : super(key: key);

  @override
  State<WebViewPrivacyPage> createState() => _WebViewPrivacyPageState();
}

class _WebViewPrivacyPageState extends State<WebViewPrivacyPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: Text(widget.title),
        ),
        body: Stack(children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                widget.isLoading = false;
              });
            },
          ),
          widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ]));
  }
}
