import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funiroll/components/anime_list.dart';
import 'package:funiroll/controllers/midia_controller.dart';
import 'package:funiroll/states/selected_animes_states.dart';
import 'package:funiroll/stores/animes/animes_providers_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_provider_store.dart';
import 'package:funiroll/utils/show_toast.dart';
import 'package:funiroll/utils/utils.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';
import 'package:funiroll/views/midia_view/components/item_episodio.dart';
import 'package:funiroll/views/midia_view/components/tabbar_temporadas.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidiaProvider extends StatefulWidget {
  const MidiaProvider({Key? key}) : super(key: key);

  @override
  State<MidiaProvider> createState() => _MidiaProviderState();
}

class _MidiaProviderState extends State<MidiaProvider> {
  @override
  Widget build(BuildContext context) {
    final midiaController = context.read<MidiaController>();
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.fromLTRB(25, 40, 25, 10),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0),
            spreadRadius: 0.5,
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 0,
            width: 0,
            child: WebView(
              gestureNavigationEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: 'https://www.themoviedb.org/login',
              onWebViewCreated: (controller) =>
                  midiaController.webViewController = controller,
              onPageFinished: (url) async {
                String status = (await midiaController.webViewController
                        .runJavascriptReturningResult(
                            "if (document.querySelector(\"header > div > div\").querySelector(\"li > a[href*=\\\"login\\\"]\") == null){\"Logado\"}else{\"Deslogado\"}"))
                    .replaceAll("\"", "");
                if (status == "Logado") {
                  final result =
                      RegExp(r'https://www\.themoviedb\.org/tv/.+/edit.*')
                          .firstMatch(url);
                  if (result != null &&
                      midiaController.episodioForProvider != null) {
                    await midiaController.webViewController.runJavascript(
                        "document.querySelector(\"input#pt_BR_name\").value = decodeURIComponent(\"${toTMDBString(midiaController.episodioForProvider!.titulo)}\");");
                    await midiaController.webViewController.runJavascript(
                        "document.querySelector(\"textarea#pt_BR_overview\").value = decodeURIComponent(\"${toTMDBString(midiaController.episodioForProvider!.descricao)}\");");
                    await Future.delayed(const Duration(seconds: 1));
                    await midiaController.webViewController.runJavascript(
                        "document.querySelector(\"input#submit.save\").click();");
                    showToast("Salvo!", color: Colors.green);
                  }
                } else {
                  showToast("Faça Login no TMDB!");
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/tmdb_letras.svg",
                  color: const Color.fromARGB(255, 144, 206, 161),
                  height: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: context.read<SelectedAnimeProviderStore>(),
              builder: (constext, state, child) {
                if (state is CompletedSelectedAnimeState) {
                  return TabBarTemporadas(
                    temporadas: state.anime.temporadas,
                    episodioItem: (_, episodio) => ItemEpisodio(
                      episodio: episodio,
                      buttoms: [
                        MyButtom(
                          fontSize: 8,
                          height: 25,
                          width: 75,
                          label: "SALVAR",
                          onPressed: () {
                            context
                                .read<MidiaController>()
                                .webViewController
                                .loadUrl(
                                    "https://www.themoviedb.org/tv/${episodio.temporada.anime.id}/season/${episodio.temporada.numero}/episode/${episodio.numero}/edit");
                          },
                        ),
                      ],
                    ),
                  );
                } else if (state is ChangedSelectedAnimeState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                } else if (state is LoadingSelectedAnimeState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Obtendo as Informações",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Bree Serif",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ],
                  );
                } else {
                  return AnimeListAnimated(
                    animeStore: context.read<AnimesProvidersStore>(),
                    stream: null,
                    onSelectAnime: (_, anime) {
                      context
                          .read<SelectedAnimeProviderStore>()
                          .changeSelectedAnime(anime);
                      final store = context.read<SelectedAnimeProviderStore>();
                      store.fetchAnimeInformations();
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
