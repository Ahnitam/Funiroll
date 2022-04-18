import 'package:flutter/material.dart';
import 'package:funiroll/models/page.dart';
import 'package:funiroll/views/home_view/pages/buscar_page/buscar_page.dart';
import 'package:funiroll/views/home_view/pages/config_page/config_page.dart';
import 'package:funiroll/views/home_view/pages/downloads_page/downloads_page.dart';

class HomeController extends ChangeNotifier {
  final List<PageModel> pages = [
    PageModel(titulo: "Buscar", page: const BuscarPage(), icon: const Icon(Icons.search_rounded)),
    PageModel(titulo: "Downloads", page: const DownloadsPage(), icon: const Icon(Icons.download_rounded)),
    PageModel(titulo: "Configurações", page: const ConfigPage(), icon: const Icon(Icons.settings_rounded)),
  ];

  late int pageAtual;
  late final PageController pageController;

  HomeController() {
    pageAtual = 0;
    pageController = PageController();
  }

  changePageAtual(int page) {
    pageAtual = page;
    notifyListeners();
  }
}
