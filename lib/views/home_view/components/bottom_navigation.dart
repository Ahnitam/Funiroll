import 'package:flutter/material.dart';
import 'package:funiroll/controllers/home_controller.dart';
import 'package:provider/provider.dart';

class MyBottomNavigation extends StatelessWidget {
  const MyBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: -10, blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.green.shade900,
          currentIndex: homeController.pageAtual,
          onTap: (p) => homeController.pageController.jumpToPage(p),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          selectedItemColor: Colors.grey.shade200,
          unselectedItemColor: Colors.black87,
          showUnselectedLabels: false,
          items: List<BottomNavigationBarItem>.generate(
            homeController.pages.length,
            (index) => BottomNavigationBarItem(
              icon: homeController.pages[index].icon,
              label: homeController.pages[index].titulo,
            ),
          ),
        ),
      ),
    );
  }
}
