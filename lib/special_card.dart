import 'package:flutter/material.dart';
import 'package:quote/main.dart';
import 'main.dart';

class SpecialCard extends StatefulWidget {

   static late Quote quote ;

  const SpecialCard({Key? key}) : super(key: key);


  @override
  State<SpecialCard> createState() => _SpecialCardState();
}

class _SpecialCardState extends State<SpecialCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Quote of the Day"),
        backgroundColor: Colors.black,
      ),

      body: Center(

        child: Wrap(
          children: [
          Card(
                margin: const EdgeInsets.all(16),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                       Text('" ${SpecialCard.quote.quote} "',
                         style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 30,),),
                      const SizedBox(height: 16,),
                      const Divider(color: Colors.black,height: 5,thickness:1),
                      const SizedBox(height: 16,),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children : <Widget>[ Text('- ${SpecialCard.quote.author}',
                          style:const TextStyle(fontSize: 30),),],),
                    ],
                  ),
                ),
              ),

        ],),
      ),
    );
  }
}
