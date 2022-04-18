import 'package:flutter/material.dart';
import 'package:funiroll/controllers/buscar_controller.dart';
import 'package:funiroll/states/animes_states.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/stores/animes/animes_stream_store.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/utils/show_toast.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';
import 'package:provider/provider.dart';

class PesquisaWidget extends StatelessWidget {
  final TextEditingController textBuscarController = TextEditingController();

  PesquisaWidget({Key? key}) : super(key: key);

  _enviar(Function(String, StreamType) buscar, StreamType stream) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (textBuscarController.text.length > 3) {
      buscar(textBuscarController.text, stream);
      textBuscarController.clear();
    } else {
      showToast("Digite mais de 3 letras");
    }
  }

  @override
  Widget build(BuildContext context) {
    final buscarController = context.watch<BuscarController>();
    final store = context.watch<AnimesStreamStore>();
    final storeA = context.watch<StreamsLoginStore>();
    final StreamType stream = context
        .read<Map<StreamType, Stream>>()
        .keys
        .elementAt(buscarController.getTabIndex());

    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
        height: 50,
        color: const Color.fromARGB(255, 33, 33, 33),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  onEditingComplete: () {
                    if (storeA.logins[stream]! is StreamSucessLoginState) {
                      if (store.value is LoadingAnimeState) {
                        showToast("Busca em andamento!", color: Colors.amber);
                      } else {
                        _enviar(context.read<AnimesStreamStore>().buscarAnimes,
                            stream);
                      }
                    } else {
                      showToast("Faça Login!");
                    }
                  },
                  readOnly: (store.value is LoadingAnimeState ||
                          storeA.logins[stream]! is! StreamSucessLoginState)
                      ? true
                      : false,
                  keyboardType: TextInputType.text,
                  controller: textBuscarController,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 0.0),
                    isDense: true,
                    labelText: "ANIME",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(0, 0, 0, 0),
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(0, 0, 0, 0),
                        width: 0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Color.fromARGB(255, 27, 94, 32),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: MyButtom(
                borderRadius: BorderRadius.zero,
                label: "BUSCAR",
                width: 70,
                height: double.infinity,
                onPressed: () {
                  if (storeA.logins[stream]! is StreamSucessLoginState) {
                    if (store.value is LoadingAnimeState) {
                      showToast("Busca em andamento!", color: Colors.amber);
                    } else {
                      _enviar(context.read<AnimesStreamStore>().buscarAnimes,
                          stream);
                    }
                  } else {
                    showToast("Faça Login!");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
