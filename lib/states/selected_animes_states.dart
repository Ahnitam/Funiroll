import 'package:funiroll/models/anime.dart';

abstract class SelectedAnimeState {}

class InitialSelectedAnimeState extends SelectedAnimeState {}

class LoadingSelectedAnimeState extends SelectedAnimeState {
  final Anime anime;
  LoadingSelectedAnimeState(this.anime);
}

class ChangedSelectedAnimeState extends SelectedAnimeState {
  final Anime anime;
  ChangedSelectedAnimeState(this.anime);
}

class CompletedSelectedAnimeState extends SelectedAnimeState {
  final Anime anime;
  CompletedSelectedAnimeState(this.anime);
}

class ErrorSelectedAnimeState extends SelectedAnimeState {
  final String menssage;
  ErrorSelectedAnimeState(this.menssage);
}
