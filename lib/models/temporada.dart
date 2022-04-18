import 'package:funiroll/models/anime.dart';
import 'package:funiroll/models/episodio.dart';

class Temporada {
  final String id;
  final String titulo;
  final String numero;
  final List<Episodio> episodios = [];

  final Anime anime;

  Temporada({required this.id, required this.titulo, required this.anime, required this.numero});
}
