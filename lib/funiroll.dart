import 'package:flutter/material.dart';
import 'package:funiroll/controllers/buscar_controller.dart';
import 'package:funiroll/controllers/download_controller.dart';
import 'package:funiroll/controllers/midia_controller.dart';
import 'package:funiroll/interfaces/info_provider.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/modules/tmdb.dart';
import 'package:funiroll/stores/animes/animes_download_store.dart';
import 'package:funiroll/stores/animes/animes_providers_store.dart';
import 'package:funiroll/stores/animes/animes_stream_store.dart';
import 'package:funiroll/stores/login/providers_login_store.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_download_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_provider_store.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_stream_store.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/views/midia_view/midia_view.dart';
import 'package:funiroll/views/tmdb_view/tmdb_view.dart';
import 'package:provider/provider.dart';

import 'controllers/home_controller.dart';
import 'modules/crunchyroll.dart';
import 'views/home_view/home_view.dart';

class Funiroll extends StatelessWidget {
  const Funiroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Map<StreamType, Stream>>(
          create: (_) => {
            StreamType.crunchyroll: Crunchyroll(
              type: StreamType.crunchyroll,
              color: const Color.fromARGB(255, 214, 110, 13),
              pathLogo: "assets/icons/cr_logo.svg",
              pathLogoTexto: "assets/icons/cr_letras.svg",
            ),
          },
        ),
        Provider<Map<ProvidersType, InfoProvider>>(
          create: (_) => {
            ProvidersType.tmdb: TMDB(
              type: ProvidersType.tmdb,
              color: const Color.fromARGB(255, 144, 206, 161),
              pathLogo: "assets/icons/tmdb_logo.svg",
              pathLogoTexto: "assets/icons/tmdb_letras.svg",
            )
          },
        ),
        Provider<DownloadController>(
          create: (context) => DownloadController(
            context.read<Map<StreamType, Stream>>(),
          ),
        ),
        ChangeNotifierProvider<StreamsLoginStore>(
          create: (context) => StreamsLoginStore(
            context.read<Map<StreamType, Stream>>(),
          ),
        ),
        ChangeNotifierProvider<ProvidersLoginStore>(
          create: (context) => ProvidersLoginStore(
            context.read<Map<ProvidersType, InfoProvider>>(),
          ),
        ),
        ChangeNotifierProvider<AnimesStreamStore>(
          create: (context) => AnimesStreamStore(
            context.read<Map<StreamType, Stream>>(),
          ),
        ),
        ChangeNotifierProvider<AnimesDownloadStore>(
          create: (context) => AnimesDownloadStore(
            context.read<Map<StreamType, Stream>>(),
          ),
        ),
        ChangeNotifierProvider<AnimesProvidersStore>(
          create: (context) => AnimesProvidersStore(
            Provider.of<Map<ProvidersType, InfoProvider>>(context,
                listen: false),
          ),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(),
        ),
        ChangeNotifierProvider<MidiaController>(
          create: (_) => MidiaController(),
        ),
        ChangeNotifierProvider<BuscarController>(
          create: (_) => BuscarController(),
        ),
        ChangeNotifierProvider<SelectedAnimeStreamStore>(
          create: (context) => SelectedAnimeStreamStore(
            context.read<Map<StreamType, Stream>>(),
          ),
        ),
        ChangeNotifierProvider<SelectedAnimeDownloadStore>(
          create: (context) => SelectedAnimeDownloadStore(
            animeStore: context.read<SelectedAnimeStreamStore>(),
            streams: context.read<Map<StreamType, Stream>>(),
          ),
        ),
        ChangeNotifierProvider<SelectedAnimeProviderStore>(
          create: (context) => SelectedAnimeProviderStore(
            Provider.of<Map<ProvidersType, InfoProvider>>(context,
                listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.grey[500],
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.black,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeView(),
          '/tmdb': (context) => const TMDBView(),
          '/midia': (context) => const MidiaView()
        },
      ),
    );
  }
}
