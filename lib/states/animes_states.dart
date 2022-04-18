import 'package:funiroll/models/anime.dart';
import 'package:funiroll/utils/types.dart';

abstract class AnimesState {}

class InitialAnimeState extends AnimesState {}

class LoadingAnimeState extends AnimesState {}

class SucessAnimeState extends AnimesState {
  StreamType? stream;
  final List<Anime> animes;
  SucessAnimeState({required this.animes, this.stream});
}

class ErrorAnimeState extends AnimesState {
  final String menssage;
  ErrorAnimeState(this.menssage);
}
