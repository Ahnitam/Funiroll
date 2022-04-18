import 'package:flutter/material.dart';
import 'package:funiroll/models/episodio.dart';
import 'package:funiroll/utils/utils.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';

class ItemEpisodio extends StatelessWidget {
  final Episodio episodio;
  final List<MyButtom> buttoms;
  const ItemEpisodio({Key? key, required this.episodio, required this.buttoms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 135,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(169, 33, 33, 33),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                        "${formatterNum(episodio.numero)}. ${episodio.titulo}",
                        maxLines: 1,
                        style: const TextStyle(
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
                        episodio.descricao,
                        textAlign: TextAlign.justify,
                        locale: const Locale('pt', 'BR'),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 167, 167, 167),
                          fontSize: 10,
                          fontFamily: 'Bree Serif',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: double.infinity,
              width: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: (episodio.imageUrl != null) ? Image.network(episodio.imageUrl!) : null,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: buttoms,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
