import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:funiroll/models/episodio.dart';
import 'package:funiroll/models/login/login_stream.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/utils/utils.dart';
import 'package:funiroll/utils/video.dart';
import 'package:http/http.dart' as http;
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:funiroll/models/temporada.dart';
import 'package:uuid/uuid.dart';

class Crunchyroll extends Stream {
  final Uuid uuid = const Uuid();
  final String api = "api.crunchyroll.com";
  final String apiBeta = "beta-api.crunchyroll.com";

  Crunchyroll({
    required StreamType type,
    required String pathLogo,
    required String pathLogoTexto,
    required Color color,
  }) : super(
            type: type,
            pathLogo: pathLogo,
            pathLogoTexto: pathLogoTexto,
            color: color);

  @override
  Future<LoginStream> login(String user, String senha) async {
    final response = await http.post(
        Uri(
          scheme: "https",
          host: api,
          path: "/login.2.json",
          queryParameters: {
            "session_id": await _tempSession(),
            "account": user,
            "password": senha
          },
        ),
        headers: {
          "User-Agent": "Mozilla/5.0",
          "Referer": "https://crunchyroll.com/"
        });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in response.headers.values) {
        final etp = RegExp(r'etp_rt=([\w\d\-]+);').firstMatch(item);
        if (etp != null) {
          return LoginStream(
              usernameOrEmail: result["data"]["user"]["username"] ??
                  result["data"]["user"]["email"],
              session: etp.group(1)!,
              isPremium:
                  (result["data"]["user"]["premium"] == "") ? false : true,
              senha: senha,
              stream: type,
              idExternal: await _getidExternal(etp.group(1)!));
        }
      }
    }
    throw Exception("Erro get auth");
  }

  @override
  Future<LoginStream> loginBySession(String session) async {
    final token = await _betaToken(session: session);
    final response = await http.get(
        Uri(
          scheme: "https",
          host: apiBeta,
          path: "/accounts/v1/me/profile",
        ),
        headers: {
          "User-Agent": "Mozilla/5.0",
          "Referer": "https://beta.crunchyroll.com/",
          "Authorization": "Bearer $token",
        });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      final LoginStream login = LoginStream(
          usernameOrEmail: result["username"] ?? result["email"],
          session: session,
          isPremium: false,
          senha: null,
          stream: type,
          idExternal: await _getidExternal(session));
      await updateInfo(login);
      return login;
    }
    throw Exception("Erro login by Session");
  }

  Future<String> _getidExternal(String session) async {
    final token = await _betaToken(session: session);
    final response = await http.get(
        Uri(
          scheme: "https",
          host: apiBeta,
          path: "/accounts/v1/me",
        ),
        headers: {
          "User-Agent": "Mozilla/5.0",
          "Referer": "https://beta.crunchyroll.com/",
          "Authorization": "Bearer $token",
        });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      return result["external_id"];
    }
    throw Exception("Erro get external id");
  }

  @override
  Future<void> updateInfo(LoginStream login) async {
    final token = await _betaToken(session: login.session);
    final response = await http.get(
        Uri(
          scheme: "https",
          host: apiBeta,
          path: "/subs/v1/subscriptions/${login.idExternal}/benefits",
        ),
        headers: {
          "User-Agent": "Mozilla/5.0",
          "Referer": "https://beta.crunchyroll.com/",
          "Authorization": "Bearer $token",
        });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      login.isPremium = (result["total"] != 0) ? true : false;
      return;
    }
    throw Exception("Erro get auth");
  }

  Future<String> _tempSession() async {
    final response = await http.post(
        Uri(
          scheme: "https",
          host: api,
          path: "/start_session.1.json",
          queryParameters: {
            "device_id": uuid.v4(),
            "device_type": "com.crunchyroll.windows.desktop",
            "access_token": "LNDJgOit5yaRIWN"
          },
        ),
        headers: {
          "User-Agent": "Mozilla/5.0",
          "Referer": "https://crunchyroll.com/"
        });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      return result["data"]["session_id"];
    }
    throw Exception("Erro get temp Session");
  }

  Future<String> _betaToken({String? session}) async {
    if (logins[type] is StreamSucessLoginState || session != null) {
      final response = await http.post(
          Uri(scheme: "https", host: apiBeta, path: "/auth/v1/token"),
          headers: {
            "Authorization": "Basic bm9haWhkZXZtXzZpeWcwYThsMHE6",
            "Referer": "https://beta.crunchyroll.com/",
            "Cookie":
                "etp_rt=${session ?? (logins[type] as StreamSucessLoginState).user.session}"
          },
          body: {
            "grant_type": "etp_rt_cookie"
          });
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        var result = jsonDecode(utf8.decode(response.bodyBytes));
        return result["access_token"];
      }
    }
    throw Exception("Erro no Token");
  }

  Future<Map<String, String>> _signed() async {
    final token = await _betaToken();
    final response = await http
        .get(Uri(scheme: "https", host: apiBeta, path: "/index/v2"), headers: {
      "Authorization": "Bearer $token",
      "Referer": "https://beta.crunchyroll.com/"
    });
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      return {
        "bucket": result["cms"]["bucket"],
        "policy": result["cms"]["policy"],
        "signature": result["cms"]["signature"],
        "key_pair_id": result["cms"]["key_pair_id"]
      };
    }
    throw Exception("Erro obter signed/polyce/key");
  }

  @override
  Future<List<Anime>> buscar(String s) async {
    var token = await _betaToken();
    final response = await http.get(
        Uri(
            scheme: "https",
            host: apiBeta,
            path: "/content/v1/search",
            queryParameters: {"q": s, "locale": "pt-BR", "n": "10"}),
        headers: {
          "Authorization": "Bearer $token",
          "Referer": "https://beta.crunchyroll.com/"
        });
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      List<Anime> animes = [];
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["items"]) {
        if (item["type"] == "series") {
          for (var anime in item["items"]) {
            animes.add(Anime(
                stream: type,
                id: anime['id'],
                titulo: anime['title'],
                descricao: anime['description'],
                imageUrl: anime["images"]["poster_tall"][0][1]["source"]));
          }
        }
      }
      return animes;
    }
    throw Exception("Erro na Busca");
  }

  @override
  Future<void> getEpisodios(
      Temporada temporada, Map<String, String> signed) async {
    final response = await http.get(
        Uri(
            scheme: "https",
            host: apiBeta,
            path: "/cms/v2${signed["bucket"]}/episodes",
            queryParameters: {
              "season_id": temporada.id,
              "locale": "pt-BR",
              "Signature": signed["signature"],
              "Policy": signed["policy"],
              "Key-Pair-Id": signed["key_pair_id"]
            }),
        headers: {"Referer": "https://beta.crunchyroll.com/"});
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["items"]) {
        final Episodio episodio = Episodio(
          id: item["id"],
          titulo: item["title"],
          descricao: item["description"],
          streamLink: (!item["is_premium_only"] ||
                  (logins[type] as StreamSucessLoginState).user.isPremium)
              ? item["__links__"]["streams"]["href"]
              : "",
          isPremium: item["is_premium_only"],
          isDub: item["is_dubbed"],
          duracao: Duration(milliseconds: item["duration_ms"]),
          imageUrl: (item["images"]["thumbnail"] != null)
              ? item["images"]["thumbnail"][0][0]["source"]
              : null,
          numero: item["episode_number"]?.toString() ?? "0",
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
    final signed = await _signed();
    final response = await http.get(
        Uri(
            scheme: "https",
            host: apiBeta,
            path: "/cms/v2${signed["bucket"]}/seasons",
            queryParameters: {
              "series_id": anime.id,
              "locale": "pt-BR",
              "Signature": signed["signature"],
              "Policy": signed["policy"],
              "Key-Pair-Id": signed["key_pair_id"]
            }),
        headers: {"Referer": "https://beta.crunchyroll.com/"});
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      anime.temporadas.clear();
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["items"]) {
        final Temporada temporada = Temporada(
          id: item["id"],
          titulo: item["title"],
          numero: item["season_number"].toString(),
          anime: anime,
        );
        await getEpisodios(temporada, signed);
        anime.temporadas.add(temporada);
      }
      return;
    }
    throw Exception("Erro ao buscar temporadas");
  }

  Future<Map<String, dynamic>> _getStreamVideo(String streamLink) async {
    final signed = await _signed();
    final response = await http.get(
        Uri(scheme: "https", host: apiBeta, path: streamLink, queryParameters: {
          "locale": "pt-BR",
          "Signature": signed["signature"],
          "Policy": signed["policy"],
          "Key-Pair-Id": signed["key_pair_id"]
        }),
        headers: {"Referer": "https://beta.crunchyroll.com/"});
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw Exception("Erro ao buscar temporadas");
  }

  String _toStaticLink(String link) {
    final assets =
        RegExp(r'https:\/\/.+\/evs.{0,1}\/(.+)\/assets\/(.+\.(mp4|ass|txt))')
            .firstMatch(link)!;
    return "https://fy.v.vrv.co/evs/${assets.group(1)}/assets/${assets.group(2)}";
  }

  Future<void> _addDownload({
    required String streamLink,
    required Map<String, dynamic> download,
    required bool isDual,
  }) async {
    final resultado = await _getStreamVideo(streamLink);
    final streams = await getStreams(
        resultado["streams"]["adaptive_hls"][""]["url"],
        headers: null);
    bool isDub = false;
    if (streams != null) {
      if (resultado["audio_locale"].toString().toUpperCase() == "JA-JP") {
        download["streams"]["video"]["leg"] = {
          "url":
              _toStaticLink(await getAdaptUrl(streams["VIDEO"]!, min: false)),
        };
      } else if (resultado["audio_locale"].toString().toUpperCase() ==
          "PT-BR") {
        isDub = true;
        download["streams"]["video"]["dub"] = {
          "url":
              _toStaticLink(await getAdaptUrl(streams["VIDEO"]!, min: false)),
        };
      }
      if (streams["AUDIO"] != null) {
        if (resultado["audio_locale"].toString().toUpperCase() == "JA-JP") {
          download["streams"]["audio"]["leg"] = {
            "url": streams["AUDIO"]![0]["url"],
          };
        } else if (resultado["audio_locale"].toString().toUpperCase() ==
            "PT-BR") {
          if (isDual) {
            (download["streams"]["video"] as Map).remove("dub");
          }
          isDub = true;
          download["streams"]["audio"]["dub"] = {
            "url": streams["AUDIO"]![0]["url"],
          };
        }
      }
    } else {
      if (resultado["audio_locale"].toString().toUpperCase() == "JA-JP") {
        download["streams"]["video"]["leg"] = {
          "url": resultado["streams"]["adaptive_hls"][""]["url"],
        };
      } else if (resultado["audio_locale"].toString().toUpperCase() ==
          "PT-BR") {
        isDub = true;
        download["streams"]["video"]["dub"] = {
          "url": resultado["streams"]["adaptive_hls"][""]["url"],
        };
      }
    }

    if (isDub) {
      download["streams"]["legenda"]["dub"] = {
        "url": _toStaticLink(resultado["subtitles"]["pt-BR"]["url"]),
        "tipo":
            resultado["subtitles"]["pt-BR"]["format"].toString().toLowerCase(),
      };
    } else {
      download["streams"]["legenda"]["leg"] = {
        "url": _toStaticLink(resultado["subtitles"]["pt-BR"]["url"]),
        "tipo":
            resultado["subtitles"]["pt-BR"]["format"].toString().toLowerCase(),
      };
    }
  }

  @override
  Future<void> download(
      {required Episodio episodio, Episodio? episodioDub}) async {
    Map<String, dynamic> download = {
      "titulo":
          "${episodio.temporada.anime.titulo} - S${formatterNum(episodio.temporada.numero)}E${formatterNum(episodio.numero)}",
      "tipo": (episodioDub != null) ? "Dual Audio" : "Legendado",
      "stream": episodio.temporada.anime.stream.name.capitalize(),
      "duracao": episodio.duracao.inMilliseconds,
      "season": episodio.temporada.id,
      "streams": {
        "video": {},
        "audio": {},
        "legenda": {},
      }
    };
    try {
      await _addDownload(
          streamLink: episodio.streamLink,
          download: download,
          isDual: (episodioDub != null) ? true : false);
      if (episodioDub != null) {
        await _addDownload(
            streamLink: episodioDub.streamLink,
            download: download,
            isDual: true);
      }

      await FirebaseFirestore.instance
          .collection("downloads")
          .doc("fila")
          .collection("items")
          .doc(episodio.id)
          .set(download);

      debugPrint(jsonEncode(download));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
