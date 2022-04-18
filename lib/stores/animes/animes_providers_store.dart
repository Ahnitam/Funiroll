import 'package:flutter/cupertino.dart';
import 'package:funiroll/interfaces/info_provider.dart';
import 'package:funiroll/states/animes_states.dart';
import 'package:funiroll/utils/types.dart';

class AnimesProvidersStore extends ValueNotifier<AnimesState> {
  final Map<ProvidersType, InfoProvider> providers;
  AnimesProvidersStore(this.providers) : super(InitialAnimeState());

  Future buscarAnimes(String s) async {
    value = LoadingAnimeState();
    try {
      final animes = await providers[ProvidersType.tmdb]!.buscar(s);
      value = SucessAnimeState(animes: animes);
    } catch (e) {
      value = ErrorAnimeState(e.toString());
    }
  }
}
