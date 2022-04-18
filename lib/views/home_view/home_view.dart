import 'package:flutter/material.dart';
import 'package:funiroll/controllers/home_controller.dart';
import 'package:funiroll/stores/login/providers_login_store.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/views/home_view/components/bottom_navigation.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController homeController;

  @override
  void initState() {
    Provider.of<StreamsLoginStore>(context, listen: false).checkLogins();
    Provider.of<ProvidersLoginStore>(context, listen: false).checkLogins();
    homeController = Provider.of<HomeController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 0,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: homeController.pageController,
        children: List<Widget>.generate(homeController.pages.length,
            (index) => homeController.pages[index].page),
        onPageChanged: homeController.changePageAtual,
      ),
      bottomNavigationBar: const MyBottomNavigation(),
    );
  }
}
