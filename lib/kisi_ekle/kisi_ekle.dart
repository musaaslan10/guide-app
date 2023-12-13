import 'package:api_tutorial/main.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class KisiEkle extends StatefulWidget {
  const KisiEkle({super.key});

  @override
  State<KisiEkle> createState() => _KisiEkleState();
}

class _KisiEkleState extends State<KisiEkle> {
  var kisi_ad = TextEditingController();
  var kisi_tel = TextEditingController();

  Future<void> kisiKayit(String kisi_ad, String kisi_tel) async {
    var url = Uri.parse("https://www.musaslan.com/test/insert_kisiler.php");
    var veri = {"kisi_ad": kisi_ad, "kisi_tel": kisi_tel};
    var cevap = await http.post(url, body: veri);
    print("ekle cevap : ${cevap.body}");
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent.shade400,
          title: const Text("KİŞİ EKLE"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: kisi_ad,
                  decoration: const InputDecoration(
                    labelText: "Ad",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: kisi_tel,
                  decoration: const InputDecoration(
                    labelText: "Telefon Numarası",
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.group_add_outlined),
            onPressed: () {
              kisiKayit(kisi_ad.text, kisi_tel.text);
            },
            label: const Text("Kaydet")),
      ),
    );
  }
}
