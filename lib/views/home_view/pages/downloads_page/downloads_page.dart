import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final List<String> estadosDownload = [
    "fila",
    "andamento",
    "baixado",
    "concluido",
    "error"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: estadosDownload.length,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
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
                      estadosDownload.length,
                      (index) => Tab(
                        child: Text(
                          estadosDownload[index].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'Bree Serif',
                          ),
                        ),
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
                children: List<Widget>.generate(
                  estadosDownload.length,
                  (index) {
                    return FutureBuilder(
                      future: getDownloads(estadosDownload[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.hasError) {
                            return Container();
                          } else {
                            var listDownloads = snapshot.data as List<
                                QueryDocumentSnapshot<Map<String, dynamic>>>;
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: listDownloads.length,
                              itemBuilder: (context, i) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(169, 33, 33, 33),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 5,
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(listDownloads
                                        .elementAt(i)
                                        .data()["titulo"]),
                                    subtitle: Text(listDownloads
                                            .elementAt(i)
                                            .data()["status"] ??
                                        ""),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("downloads")
                                            .doc(estadosDownload[index])
                                            .collection("items")
                                            .doc(listDownloads.elementAt(i).id)
                                            .delete();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDownloads(
      String estado) async {
    return (await FirebaseFirestore.instance
            .collection("downloads")
            .doc(estado)
            .collection("items")
            .get())
        .docs;
  }
}
