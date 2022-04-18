import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

Future<Map<String, List<Map<String, dynamic>>?>?> getStreams(String link, {required Map<String, String>? headers}) async {
  try {
    final Map<String, List<Map<String, dynamic>>?> streams = {};

    streams["AUDIO"] = null;
    streams["VIDEO"] = [];

    try {
      final response = await http.get(Uri.parse(link), headers: headers);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final results = utf8.decode(response.bodyBytes);
        if (results.contains("TYPE=AUDIO")) {
          final audio = RegExp(r'EXT.+TYPE=AUDIO.+').firstMatch(results);
          if (audio != null) {
            final audioTemp = RegExp(r'https://.+').firstMatch(audio.group(0)!.replaceAll("\"", ""));
            streams["AUDIO"] = [];
            streams["AUDIO"]!.add(
              {
                "url": audioTemp!.group(0)
              },
            );
          }
        }
        final streamsTemp = RegExp(r'EXT-X-STREAM-INF.+\n.+').allMatches(results);
        for (var str in streamsTemp) {
          final stream = str.group(0)!.split("\n");
          final brandTemp = RegExp(r'[:,\s]BANDWIDTH=\d+').firstMatch(stream[0])!.group(0)!.split("=");
          streams["VIDEO"]!.add({
            "url": stream[1],
            "bandwidth": int.parse(brandTemp[1].toString()),
          });
        }
        if (streams["VIDEO"]!.isNotEmpty) {
          return streams;
        } else {
          throw Exception("Nenhum Stream Encontrado");
        }
      } else {
        throw Exception("Erro na requisição");
      }
    } catch (e) {
      throw Exception("Erro na requisição");
    }
  } catch (e) {
    return null;
  }
}

Future<String> getAdaptUrl(List<Map<String, dynamic>> streams, {bool min = false}) async {
  Map<String, dynamic>? stream;
  if (min) {
    for (var s in streams) {
      if (stream == null || s["bandwidth"] < stream["bandwidth"]) {
        stream = s;
      }
    }
  } else {
    for (var s in streams) {
      if (stream == null || s["bandwidth"] > stream["bandwidth"]) {
        stream = s;
      }
    }
  }
  return stream!["url"];
}
