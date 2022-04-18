import 'package:flutter/material.dart';
import 'package:funiroll/models/anime.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';

class ItemBusca extends StatelessWidget {
  final Anime anime;
  final Animation<double> animation;
  final VoidCallback onSelectAnime;

  const ItemBusca({Key? key, required this.anime, required this.animation, required this.onSelectAnime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      key: UniqueKey(),
      opacity: animation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          color: const Color.fromARGB(169, 33, 33, 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 180,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      blurRadius: 20,
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (anime.imageUrl != null)
                      ? Image.network(
                          anime.imageUrl!,
                          filterQuality: FilterQuality.high,
                        )
                      : null,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          anime.titulo,
                          maxLines: 1,
                          style: const TextStyle(
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset.zero,
                                blurRadius: 20,
                              )
                            ],
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Bree Serif',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          anime.descricao,
                          textAlign: TextAlign.justify,
                          locale: const Locale('pt', 'BR'),
                          style: const TextStyle(
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset.zero,
                                blurRadius: 20,
                              )
                            ],
                            color: Color.fromARGB(255, 167, 167, 167),
                            fontSize: 10,
                            fontFamily: 'Bree Serif',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: MyButtom(
                        height: 40,
                        width: 80,
                        onPressed: onSelectAnime,
                        label: "SELECIONAR",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
