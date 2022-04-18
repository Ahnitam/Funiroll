import 'package:flutter/material.dart';
import 'package:funiroll/interfaces/info_provider.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/states/selected_animes_states.dart';
import 'package:funiroll/utils/types.dart';

class SelectedAnimeProviderStore extends ValueNotifier<SelectedAnimeState> {
  Map<ProvidersType, InfoProvider> providers;
  SelectedAnimeProviderStore(this.providers)
      : super(InitialSelectedAnimeState());

  Future fetchAnimeInformations() async {
    try {
      value =
          LoadingSelectedAnimeState((value as ChangedSelectedAnimeState).anime);
      await providers[ProvidersType.tmdb]!
          .getTemporadas((value as LoadingSelectedAnimeState).anime);
      value = CompletedSelectedAnimeState(
          (value as LoadingSelectedAnimeState).anime);
    } catch (e) {
      value = ErrorSelectedAnimeState(e.toString());
    }
  }

  changeSelectedAnime(Anime anime) {
    value = ChangedSelectedAnimeState(anime.copyWith(temporadas: []));
  }
}
