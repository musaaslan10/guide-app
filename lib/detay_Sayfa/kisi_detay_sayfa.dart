// ignore_for_file: must_be_immutable

import 'package:api_tutorial/Kisiler.dart';
import 'package:api_tutorial/main.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class KisiDetay extends StatefulWidget {
  KisiDetay({super.key, required this.kisiler});
  Kisiler kisiler;

  @override
  State<KisiDetay> createState() => _KisiDetayState();
}

class _KisiDetayState extends State<KisiDetay> {
  var kisi_ad = TextEditingController();
  var kisi_tel = TextEditingController();

  Future<void> kisiGuncelle(
      int kisi_id, String kisi_ad, String kisi_tel) async {
    var url = Uri.parse("https://www.musaslan.com/test/update_kisiler.php");
    var veri = {
      "kisi_id": kisi_id.toString(),
      "kisi_ad": kisi_ad,
      "kisi_tel": kisi_tel
    };
    var cevap = await http.post(url, body: veri);
    print("ekle cevap : ${cevap.body}");
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  void initState() {
    super.initState();
    var kisi = widget.kisiler;
    kisi_ad.text = kisi.kisi_ad;
    kisi_tel.text = kisi.kisi_tel;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("KİŞİ DETAY"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Ad",
                      border: OutlineInputBorder(),
                    ),
                    controller: kisi_ad),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Telefon Numarası",
                      border: OutlineInputBorder(),
                    ),
                    controller: kisi_tel),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Güncelle"),
          onPressed: () {
            kisiGuncelle(
                int.parse(widget.kisiler.kisi_id), kisi_ad.text, kisi_tel.text);
          },
          tooltip: "Kişiyi Güncelle",
          icon: const Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }
}
