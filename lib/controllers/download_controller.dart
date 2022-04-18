import 'package:funiroll/models/episodio.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/interfaces/stream.dart';

class DownloadController {
  final Map<StreamType, Stream> streams;

  DownloadController(this.streams);

  download({required Episodio episodio, Episodio? episodioDub}) {
    streams[episodio.temporada.anime.stream]!
        .download(episodio: episodio, episodioDub: episodioDub);
  }
}
