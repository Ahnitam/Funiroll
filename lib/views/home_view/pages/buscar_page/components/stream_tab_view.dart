import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funiroll/components/anime_list.dart';
import 'package:funiroll/controllers/buscar_controller.dart';
import 'package:funiroll/states/animes_states.dart';
import 'package:funiroll/states/selected_animes_states.dart';
import 'package:funiroll/stores/animes/animes_download_store.dart';
import 'package:funiroll/stores/animes/animes_providers_store.dart';
import 'package:funiroll/stores/animes/animes_stream_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_download_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_provider_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_stream_store.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:provider/provider.dart';

class StreamTabView extends StatefulWidget {
  const StreamTabView({Key? key}) : super(key: key);

  @override
  State<StreamTabView> createState() => _StreamTabViewState();
}

class _StreamTabViewState extends State<StreamTabView>
    with TickerProviderStateMixin {
  late final BuscarController buscarController;
  late final Map<StreamType, Stream> streams;

  @override
  void initState() {
    streams = context.read<Map<StreamType, Stream>>();
    buscarController = context.read<BuscarController>();
    buscarController.tabController =
        TabController(length: streams.length, vsync: this);
    buscarController.tabController!.addListener(() {
      buscarController.mudou();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: ThemeData().copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              child: TabBar(
                controller: buscarController.tabController,
                indicatorColor: Colors.green[900],
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(155, 33, 33, 33),
                ),
                tabs: List<Tab>.generate(
                  streams.length,
                  (index) => Tab(
                    icon: SvgPicture.asset(
                      streams.values.elementAt(index).pathLogo,
                      width: 25,
                      color: streams.values.elementAt(index).color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: buscarController.tabController,
              physics: const BouncingScrollPhysics(),
              children: List<Widget>.generate(
                streams.length,
                (index) => AnimeListAnimated(
                  animeStore: context.read<AnimesStreamStore>(),
                  onSelectAnime: (_, anime) {
                    context.read<SelectedAnimeProviderStore>().value =
                        InitialSelectedAnimeState();
                    context.read<AnimesProvidersStore>().value =
                        InitialAnimeState();

                    context.read<SelectedAnimeDownloadStore>().value =
                        InitialSelectedAnimeState();
                    context.read<AnimesDownloadStore>().value =
                        InitialAnimeState();

                    context
                        .read<SelectedAnimeStreamStore>()
                        .changeSelectedAnime(anime);
                    Navigator.pushNamed(context, "/midia");
                  },
                  stream: streams.keys.elementAt(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
