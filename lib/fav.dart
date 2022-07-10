import 'package:flutter/material.dart';
import 'package:quote/quote_fev_view.dart';
import 'main.dart';


class Fav extends StatefulWidget {
  static Set<Quote> savedQuote = {} ;

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  @override

  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text("Favorites"),
          backgroundColor: Colors.black,
        ),

      body: buildPage(Fav.savedQuote),


    );
  }
}

Widget buildPage(Set<Quote> list){
  return ListView(
    children: list.map((e) => QuoteFevCard(
      quote: e,
    )).toList(),

  );
}