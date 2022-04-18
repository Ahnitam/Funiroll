import 'package:flutter/material.dart';
import 'package:funiroll/controllers/download_controller.dart';
import 'package:funiroll/controllers/midia_controller.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/states/selected_animes_states.dart';
import 'package:funiroll/stores/animes/animes_download_store.dart';
import 'package:funiroll/stores/animes/animes_providers_store.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_stream_store.dart';
import 'package:funiroll/utils/show_toast.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';
import 'package:funiroll/views/midia_view/components/anime_info.dart';
import 'package:funiroll/views/midia_view/components/dialog_download.dart';
import 'package:funiroll/views/midia_view/components/item_episodio.dart';
import 'package:funiroll/views/midia_view/components/tabbar_temporadas.dart';
import 'package:provider/provider.dart';

class MidiaPrincipal extends StatefulWidget {
  const MidiaPrincipal({Key? key}) : super(key: key);

  @override
  State<MidiaPrincipal> createState() => _MidiaPrincipalState();
}

class _MidiaPrincipalState extends State<MidiaPrincipal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final store = context.read<SelectedAnimeStreamStore>();
      if (store.value is ChangedSelectedAnimeState) {
        store.fetchAnimeInformations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<SelectedAnimeStreamStore>(),
      builder: (context, state, child) {
        if (state is CompletedSelectedAnimeState) {
          return AnimeInfo(
            child: TabBarTemporadas(
              temporadas: state.anime.temporadas,
              episodioItem: (_, episodio) => ItemEpisodio(
                episodio: episodio,
                buttoms: [
                  MyButtom(
                    fontSize: 8,
                    height: 25,
                    width: 50,
                    label: "TMDB",
                    onPressed: () {
                      context
                          .read<AnimesProvidersStore>()
                          .buscarAnimes(episodio.temporada.anime.titulo);
                      context.read<MidiaController>().episodioForProvider =
                          episodio;
                      context.read<MidiaController>().changePosition();
                    },
                  ),
                  MyButtom(
                    fontSize: 8,
                    height: 25,
                    width: 50,
                    label: "BAIXAR",
                    onPressed: () {
                      if (!episodio.isPremium ||
                          (context
                                      .read<StreamsLoginStore>()
                                      .logins[state.anime.stream]
                                  is StreamSucessLoginState &&
                              (context
                                          .read<StreamsLoginStore>()
                                          .logins[state.anime.stream]
                                      as StreamSucessLoginState)
                                  .user
                                  .isPremium)) {
                        if (episodio.isDub) {
                          showToast("Selecione o episodio legendado!",
                              color: Colors.amber);
                          context
                              .read<AnimesDownloadStore>()
                              .buscarAnimes(state.anime);
                          showDialog(
                            context: context,
                            builder: (_) =>
                                DialogDownload(episodioDub: episodio),
                          );
                        } else {
                          context
                              .read<DownloadController>()
                              .download(episodio: episodio);
                        }
                      } else {
                        showToast("Faça login em uma conta Premium!");
                      }
                    },
                  ),
                ],
              ),
            ),
            titulo: state.anime.titulo,
          );
        } else if (state is ChangedSelectedAnimeState) {
          return AnimeInfo(
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
            titulo: state.anime.titulo,
          );
        } else if (state is LoadingSelectedAnimeState) {
          return AnimeInfo(
            child: Column(
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
            ),
            titulo: state.anime.titulo,
          );
        } else {
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 240,
                  width: 200,
                  child: Image.asset("assets/images/saitama.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Busque por um anime",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Bree Serif",
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
