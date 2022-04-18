import 'package:flutter/material.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/states/selected_animes_states.dart';
import 'package:funiroll/utils/types.dart';

class SelectedAnimeStreamStore extends ValueNotifier<SelectedAnimeState> {
  Map<String, Anime> cacheAnimes = {};
  Map<StreamType, Stream> streams;
  SelectedAnimeStreamStore(this.streams) : super(InitialSelectedAnimeState());

  Future fetchAnimeInformations() async {
    try {
      value =
          LoadingSelectedAnimeState((value as ChangedSelectedAnimeState).anime);
      await streams[(value as LoadingSelectedAnimeState).anime.stream]!
          .getTemporadas((value as LoadingSelectedAnimeState).anime);
      cacheAnimes[(value as LoadingSelectedAnimeState).anime.id] =
          (value as LoadingSelectedAnimeState).anime;
      value = CompletedSelectedAnimeState(
          (value as LoadingSelectedAnimeState).anime);
    } catch (e) {
      value = ErrorSelectedAnimeState(e.toString());
    }
  }

  changeSelectedAnime(Anime anime) {
    value = (cacheAnimes[anime.id] != null)
        ? CompletedSelectedAnimeState(cacheAnimes[anime.id]!)
        : ChangedSelectedAnimeState(anime);
  }
}
