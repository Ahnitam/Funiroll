import 'package:flutter/material.dart';
import 'package:funiroll/models/episodio.dart';
import 'package:funiroll/models/login/login_stream.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/models/temporada.dart';

abstract class Stream {
  final StreamType type;
  late Map<StreamType, StreamLoginState> logins;
  final Color color;
  final String pathLogo;
  final String pathLogoTexto;

  Stream(
      {required this.type,
      required this.pathLogo,
      required this.pathLogoTexto,
      required this.color});

  Future<LoginStream> login(String user, String senha);
  Future<LoginStream> loginBySession(String session);
  Future<void> updateInfo(LoginStream login);
  Future<List<Anime>> buscar(String s);
  Future<void> getTemporadas(Anime anime);
  Future<void> download({required Episodio episodio, Episodio? episodioDub});
  Future<void> getEpisodios(Temporada temporada, Map<String, String> signed);
}
