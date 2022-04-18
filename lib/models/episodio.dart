import 'package:funiroll/models/temporada.dart';

class Episodio {
  final String id;
  final String titulo;
  final String descricao;
  final bool isPremium;
  final bool isDub;
  final Duration duracao;
  final String streamLink;
  final String numero;
  final Temporada temporada;
  String? imageUrl;

  Episodio({required this.id, required this.isDub, required this.streamLink, required this.duracao, required this.isPremium, required this.titulo, required this.descricao, required this.temporada, required this.numero, this.imageUrl});
}
