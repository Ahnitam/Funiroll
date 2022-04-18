import 'package:flutter/material.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/states/animes_states.dart';
import 'package:funiroll/components/item_busca.dart';
import 'package:funiroll/utils/types.dart';

class AnimeListAnimated extends StatefulWidget {
  final ValueNotifier<AnimesState> animeStore;
  final StreamType? stream;
  final Function(BuildContext, Anime) onSelectAnime;
  const AnimeListAnimated(
      {Key? key,
      required this.animeStore,
      required this.onSelectAnime,
      required this.stream})
      : super(key: key);

  @override
  State<AnimeListAnimated> createState() => _AnimeListAnimatedState();
}

class _AnimeListAnimatedState extends State<AnimeListAnimated>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: widget.animeStore,
      builder: (context, state, child) {
        if (state is SucessAnimeState && state.stream == widget.stream) {
          return AnimatedList(
            key: GlobalKey(),
            initialItemCount: state.animes.length,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: ((context, index, animation) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: ItemBusca(
                    anime: state.animes[index],
                    animation: animation,
                    onSelectAnime: () =>
                        widget.onSelectAnime(context, state.animes[index]),
                  ),
                )),
          );
        } else if (state is LoadingAnimeState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
