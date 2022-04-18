import 'package:flutter/cupertino.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/states/animes_states.dart';
import 'package:funiroll/utils/types.dart';

class AnimesStreamStore extends ValueNotifier<AnimesState> {
  final Map<StreamType, Stream> streams;

  AnimesStreamStore(this.streams) : super(InitialAnimeState());

  Future buscarAnimes(String s, StreamType stream) async {
    value = LoadingAnimeState();
    try {
      final animes = await streams[stream]!.buscar(s);
      value = SucessAnimeState(animes: animes, stream: stream);
    } catch (e) {
      value = ErrorAnimeState(e.toString());
    }
  }
}
