import 'package:api_tutorial/Kisiler.dart';
import 'package:api_tutorial/detay_Sayfa/kisi_detay_sayfa.dart';
import 'package:api_tutorial/kisi_ekle/kisi_ekle.dart';
import 'package:api_tutorial/kisiler_cevap.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  List<Kisiler> parseKisilerCevap(String cevap) {
    return KisilerCevap.fromJson(json.decode(cevap)).kisilerListesi;
  }

  Future<List<Kisiler>> tumKisiler() async {
    var url = Uri.parse("https://www.musaslan.com/test/tum_kisiler.php");
    var cevap = await http.get(url);
    return parseKisilerCevap(cevap.body);
  }

  Future<void> kisiSil(int kisi_id) async {
    var url = Uri.parse("https://www.musaslan.com/test/delete_kisiler.php");
    var veri = {"kisi_id": kisi_id.toString()};
    var cevap = await http.post(url, body: veri);
    print("silme cevap : ${cevap.body}");
    setState(() {});
  }

  Future<List<Kisiler>> aramaYap(String aramaKelimesi) async {
    var url = Uri.parse("https://www.musaslan.com/test/tum_kisiler_arama.php");
    var veri = {"kisi_ad": aramaKelimesi};
    var cevap = await http.post(url, body: veri);
    return parseKisilerCevap(cevap.body);
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent.shade400,
          title: aramaYapiliyorMu
              ? TextField(
                  decoration: const InputDecoration(hintText: "Kişi Ara"),
                  onChanged: (aramaSonucu) {
                    //print("arama sonucu : $aramaSonucu");
                    setState(() {
                      aramaKelimesi = aramaSonucu;
                    });
                  },
                )
              : const Text(
                  "REHBER",
                  style: TextStyle(color: Colors.white),
                ),
          actions: [
            aramaYapiliyorMu
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        aramaYapiliyorMu = false;
                      });
                    },
                    icon: const Icon(Icons.cancel_sharp))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        aramaYapiliyorMu = true;
                        aramaKelimesi = "";
                      });
                    },
                    icon: const Icon(Icons.person_search_outlined))
          ],
        ),
        body: FutureBuilder<List<Kisiler>>(
          future: aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKisiler(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var kisiListesi = snapshot.data;
              return ListView.builder(
                itemCount: kisiListesi!.length,
                itemBuilder: (context, index) {
                  var kisi = kisiListesi[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: deviceWidth,
                            height: deviceHeight / 11,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            KisiDetay(kisiler: kisi)));
                              },
                              child: Card(
                                child: Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        kisi.kisi_ad,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        kisi.kisi_tel,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            kisiSil(int.parse(kisi.kisi_id));
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KisiEkle(),
              ),
            );
          },
          child: const Icon(Icons.person_add_rounded),
          tooltip: "KİŞİ EKLE",
        ),
      ),
    );
  }
}
