import 'package:flutter/material.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/models/login/login_provider.dart';
import 'package:funiroll/models/temporada.dart';
import 'package:funiroll/states/login/login_provider_state.dart';
import 'package:funiroll/utils/types.dart';

abstract class InfoProvider {
  final ProvidersType type;
  late Map<ProvidersType, ProviderLoginState> logins;
  final Color color;
  final String pathLogo;
  final String pathLogoTexto;
  final bool isWebLogin;

  InfoProvider({
    required this.type,
    required this.color,
    required this.pathLogo,
    required this.pathLogoTexto,
    required this.isWebLogin,
  });

  Future<LoginProvider> login(String user, String senha);
  Future<void> checkLogin(LoginProvider login);
  Future<List<Anime>> buscar(String s);
  Future<void> getTemporadas(Anime anime);
  Future<void> getEpisodios(Temporada temporada);
}
