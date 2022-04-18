import 'package:flutter/cupertino.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/states/animes_states.dart';
import 'package:funiroll/utils/types.dart';

class AnimesDownloadStore extends ValueNotifier<AnimesState> {
  final Map<StreamType, Stream> streams;

  AnimesDownloadStore(this.streams) : super(InitialAnimeState());

  Future buscarAnimes(Anime anime) async {
    value = LoadingAnimeState();
    try {
      final animes = await streams[anime.stream]!.buscar(anime.titulo);
      value = SucessAnimeState(animes: animes, stream: anime.stream);
    } catch (e) {
      value = ErrorAnimeState(e.toString());
    }
  }
}
