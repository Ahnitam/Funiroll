import 'package:flutter/material.dart';
import 'package:funiroll/components/anime_list.dart';
import 'package:funiroll/controllers/download_controller.dart';
import 'package:funiroll/models/episodio.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/states/selected_animes_states.dart';
import 'package:funiroll/stores/animes/animes_download_store.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_download_store.dart';
import 'package:funiroll/utils/show_toast.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';
import 'package:funiroll/views/midia_view/components/item_episodio.dart';
import 'package:funiroll/views/midia_view/components/tabbar_temporadas.dart';
import 'package:provider/provider.dart';

class DialogDownload extends StatelessWidget {
  final Episodio episodioDub;
  const DialogDownload({Key? key, required this.episodioDub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: context.read<SelectedAnimeDownloadStore>(),
                builder: (_, state, child) {
                  if (state is CompletedSelectedAnimeState) {
                    return TabBarTemporadas(
                      temporadas: state.anime.temporadas,
                      episodioItem: (_, episodio) => ItemEpisodio(
                        episodio: episodio,
                        buttoms: [
                          MyButtom(
                            fontSize: 8,
                            height: 25,
                            width: 80,
                            label: "CONFIRMAR",
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
                                if (!episodio.isDub) {
                                  context.read<DownloadController>().download(
                                      episodio: episodio,
                                      episodioDub: episodioDub);
                                  Navigator.pop(context);
                                } else {
                                  showToast("Selecione o episodio legendado!",
                                      color: Colors.amber);
                                }
                              } else {
                                showToast("Faça login em uma conta Premium!");
                              }
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
                      animeStore: context.read<AnimesDownloadStore>(),
                      stream: episodioDub.temporada.anime.stream,
                      onSelectAnime: (_, anime) {
                        context
                            .read<SelectedAnimeDownloadStore>()
                            .changeSelectedAnime(anime);
                        final store =
                            context.read<SelectedAnimeDownloadStore>();
                        if (store.value is ChangedSelectedAnimeState) {
                          store.fetchAnimeInformations();
                        }
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "S${episodioDub.temporada.numero} - ${episodioDub.temporada.titulo}",
                        maxLines: 1,
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "E${episodioDub.numero} - ${episodioDub.titulo}",
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
