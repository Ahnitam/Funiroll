import 'package:flutter/material.dart';
import 'package:funiroll/views/home_view/pages/buscar_page/components/pesquisa_widget.dart';
import 'package:funiroll/views/home_view/pages/buscar_page/components/stream_tab_view.dart';

class BuscarPage extends StatelessWidget {
  const BuscarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PesquisaWidget(),
          ),
          const Expanded(
            child: StreamTabView(),
          ),
        ],
      ),
    );
  }
}
