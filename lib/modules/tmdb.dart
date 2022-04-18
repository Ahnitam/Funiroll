import 'dart:convert';
import 'dart:ui';

import 'package:funiroll/interfaces/info_provider.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/models/episodio.dart';
import 'package:funiroll/models/login/login_provider.dart';
import 'package:funiroll/models/temporada.dart';
import 'package:funiroll/utils/types.dart';
import 'package:http/http.dart' as http;

class TMDB extends InfoProvider {
  final _api = "api.themoviedb.org";
  final _apiKey = "456391ba2f91200d6bb0a336d3d13223";

  TMDB({
    required ProvidersType type,
    required Color color,
    required String pathLogo,
    required String pathLogoTexto,
  }) : super(
          type: type,
          color: color,
          pathLogo: pathLogo,
          pathLogoTexto: pathLogoTexto,
          isWebLogin: true,
        );

  @override
  Future<List<Anime>> buscar(String s) async {
    final response = await http.get(
      Uri(scheme: "https", host: _api, path: "/3/search/tv", queryParameters: {
        "api_key": _apiKey,
        "language": "pt-BR",
        "page": "1",
        "query": s,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      List<Anime> animes = [];
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["results"]) {
        animes.add(
          Anime(
            stream: StreamType.crunchyroll,
            id: item['id'].toString(),
            titulo: item['name'],
            descricao: item['overview'],
            imageUrl: (item["poster_path"] != null)
                ? "https://image.tmdb.org/t/p/original" + item["poster_path"]
                : null,
          ),
        );
      }
      return animes;
    }
    throw Exception("Erro na Busca");
  }

  @override
  Future<void> getEpisodios(Temporada temporada) async {
    final response = await http.get(
      Uri(
          scheme: "https",
          host: _api,
          path: "/3/tv/${temporada.anime.id}/season/${temporada.numero}",
          queryParameters: {
            "api_key": _apiKey,
            "language": "pt-BR",
          }),
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["episodes"]) {
        final Episodio episodio = Episodio(
          streamLink: "",
          duracao: const Duration(),
          id: item["id"].toString(),
          titulo: item["name"],
          descricao: item["overview"],
          isPremium: false,
          isDub: false,
          imageUrl: (item["still_path"] != null)
              ? "https://image.tmdb.org/t/p/original" + item["still_path"]
              : null,
          numero: item["episode_number"].toString(),
          temporada: temporada,
        );
        temporada.episodios.add(episodio);
      }
      return;
    }
    throw Exception("Erro ao buscar episodios");
  }

  @override
  Future<void> getTemporadas(Anime anime) async {
    final response = await http.get(
      Uri(
          scheme: "https",
          host: _api,
          path: "/3/tv/${anime.id}",
          queryParameters: {
            "api_key": _apiKey,
          }),
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      anime.temporadas.clear();
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["seasons"]) {
        final Temporada temporada = Temporada(
          id: item["id"].toString(),
          titulo: item["name"],
          numero: item["season_number"].toString(),
          anime: anime,
        );
        await getEpisodios(temporada);
        anime.temporadas.add(temporada);
      }
      return;
    }
    throw Exception("Erro ao buscar temporadas");
  }

  @override
  Future<LoginProvider> login(String user, String senha) async {
    return LoginProvider(
        usernameOrEmail: user,
        senha: senha,
        session: "",
        provider: ProvidersType.tmdb,
        isWebLogin: true);
  }

  @override
  Future<void> checkLogin(LoginProvider login) async {
    return;
  }
}
