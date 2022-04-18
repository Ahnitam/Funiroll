import 'package:flutter/material.dart';
import 'package:funiroll/models/episodio.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidiaController extends ChangeNotifier {
  bool permitirBack = true;
  List<Widget> children = [];
  late WebViewController webViewController;
  Episodio? episodioForProvider;

  changePosition() {
    permitirBack = !permitirBack;
    children = List.from(children.reversed);
    notifyListeners();
  }
}
