import 'dart:io';

import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

class TMDBView extends StatefulWidget {
  const TMDBView({Key? key}) : super(key: key);

  @override
  State<TMDBView> createState() => _TMDBViewState();
}

class _TMDBViewState extends State<TMDBView> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 0,
      ),
      body: SizedBox(
        //width: 0,
        //height: 0,
        child: WebView(
          gestureNavigationEnabled: true,
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://www.themoviedb.org/login',
          onWebViewCreated: (controller) => this.controller = controller,
          onPageFinished: (page) async {
            //String status = (await controller.runJavascriptReturningResult("if (document.querySelector(\"header > div > div\").querySelector(\"li > a[href*=\\\"login\\\"]\") == null){\"Logado!\"}else{\"Deslogado!\"}")).replaceAll("\"", "");
          },
        ),
      ),
    );
  }
}
