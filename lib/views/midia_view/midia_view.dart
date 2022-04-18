import 'package:flutter/material.dart';
import 'package:funiroll/controllers/midia_controller.dart';
import 'package:funiroll/views/midia_view/components/principal.dart';
import 'package:funiroll/views/midia_view/components/midia_provider.dart';
import 'package:provider/provider.dart';

class MidiaView extends StatelessWidget {
  const MidiaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<MidiaController>().children = [
      MidiaProvider(key: GlobalKey()),
      MidiaPrincipal(key: GlobalKey()),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (context.read<MidiaController>().permitirBack) {
          return true;
        } else {
          context.read<MidiaController>().changePosition();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          toolbarHeight: 0,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Consumer<MidiaController>(
            builder: (context, controller, child) => Stack(
              children: controller.children,
            ),
          ),
        ),
      ),
    );
  }
}
