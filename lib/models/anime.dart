import 'package:funiroll/models/temporada.dart';
import 'package:funiroll/utils/types.dart';

class Anime {
  final String id;
  final String titulo;
  final String descricao;
  final StreamType stream;
  late final List<Temporada> temporadas;
  String? imageUrl;

  Anime(
      {required this.id,
      required this.titulo,
      required this.descricao,
      required this.stream,
      required this.imageUrl,
      List<Temporada>? temporadas}) {
    this.temporadas = temporadas ?? [];
  }

  Anime copyWith(
      {String? id,
      String? titulo,
      String? descricao,
      StreamType? stream,
      String? imageUrl,
      List<Temporada>? temporadas}) {
    return Anime(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      stream: stream ?? this.stream,
      imageUrl: imageUrl ?? this.imageUrl,
      temporadas: temporadas ?? this.temporadas,
    );
  }

  @override
  String toString() {
    return "ID: $id - Titulo: $titulo - Descrição: $descricao}";
  }
}
