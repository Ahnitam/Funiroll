import 'package:flutter/material.dart';
import 'package:funiroll/models/episodio.dart';
import 'package:funiroll/models/temporada.dart';

class TabBarTemporadas extends StatefulWidget {
  final List<Temporada> temporadas;
  final Widget Function(BuildContext, Episodio) episodioItem;
  const TabBarTemporadas({Key? key, required this.temporadas, required this.episodioItem}) : super(key: key);

  @override
  State<TabBarTemporadas> createState() => _TabBarTemporadasState();
}

class _TabBarTemporadasState extends State<TabBarTemporadas> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.temporadas.length,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: TabBar(
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Color.fromARGB(155, 19, 102, 30),
                ),
                physics: const BouncingScrollPhysics(),
                indicatorColor: Colors.green[900],
                isScrollable: true,
                tabs: List<Tab>.generate(
                  widget.temporadas.length,
                  (index) => Tab(
                    child: Text(
                      widget.temporadas[index].titulo,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: List<ListView>.generate(
                widget.temporadas.length,
                (index) => ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.temporadas[index].episodios.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: widget.episodioItem(
                        context,
                        widget.temporadas[index].episodios[i],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
