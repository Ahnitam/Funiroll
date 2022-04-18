import 'package:flutter/material.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/states/selected_animes_states.dart';
import 'package:funiroll/stores/selected_anime/selected_anime_stream_store.dart';
import 'package:funiroll/utils/types.dart';

class SelectedAnimeDownloadStore extends ValueNotifier<SelectedAnimeState> {
  Map<StreamType, Stream> streams;
  final SelectedAnimeStreamStore animeStore;
  SelectedAnimeDownloadStore({required this.streams, required this.animeStore})
      : super(InitialSelectedAnimeState());

  Future fetchAnimeInformations() async {
    try {
      value =
          LoadingSelectedAnimeState((value as ChangedSelectedAnimeState).anime);
      await streams[(value as LoadingSelectedAnimeState).anime.stream]!
          .getTemporadas((value as LoadingSelectedAnimeState).anime);
      animeStore.cacheAnimes[(value as LoadingSelectedAnimeState).anime.id] =
          (value as LoadingSelectedAnimeState).anime;
      value = CompletedSelectedAnimeState(
          (value as LoadingSelectedAnimeState).anime);
    } catch (e) {
      value = ErrorSelectedAnimeState(e.toString());
    }
  }

  changeSelectedAnime(Anime anime) {
    value = (animeStore.cacheAnimes[anime.id] != null)
        ? CompletedSelectedAnimeState(animeStore.cacheAnimes[anime.id]!)
        : ChangedSelectedAnimeState(anime);
  }
}
