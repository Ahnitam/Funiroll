import 'package:flutter/material.dart';

class BuscarController extends ChangeNotifier {
  int tabAtual = 0;
  TabController? tabController;

  int getTabIndex() {
    return tabAtual;
  }

  void mudou() {
    if (tabAtual != tabController!.index) {
      tabAtual = tabController!.index;
      notifyListeners();
    }
  }
}
