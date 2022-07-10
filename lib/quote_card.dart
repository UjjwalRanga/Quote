import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fav.dart';
import 'main.dart';

class QuoteCard extends StatefulWidget {
  static bool numbered = false;
  final Quote quote;
  final int no;
  QuoteCard({required this.quote , required this.no});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {

  Future<void> addlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('marcus', MyApp.marcusL);
    await prefs.setStringList('seneca',MyApp.senecaL);
    await prefs.setStringList('epictetus',MyApp.epictetusL);
    Fav.savedQuote.clear();
    for(int i = 0; i< MyApp.marcusL.length;i++){
      Fav.savedQuote.add(Quote(author: 'Marcus Aurelius',quote: MyApp.marcusL[i]));
    }
    for(int i = 0; i< MyApp.senecaL.length;i++){
      Fav.savedQuote.add(Quote(author: 'Seneca',quote: MyApp.senecaL[i]));
    }
    for(int i = 0; i< MyApp.epictetusL.length;i++){
      Fav.savedQuote.add(Quote(author: 'Epictetus',quote: MyApp.epictetusL[i]));
    }

  }

  bool colur(){
    if(MyApp.senecaL.contains(widget.quote.quote)){
      return true;
    }else if(MyApp.marcusL.contains(widget.quote.quote)){
      return true;
    }else if(MyApp.epictetusL.contains(widget.quote.quote)){
      return true;
    }
    return false;
  }

  void dialogBox(){
    showDialog(
        context: context,
        builder: (ctx) =>AlertDialog(
          title: Text(widget.quote.author,style: const TextStyle(fontWeight: FontWeight.bold),),
          content: Text(widget.quote.quote,style:const TextStyle(fontSize: 30,fontStyle: FontStyle.italic)),
        )
    );

  }

  void buttonStateChange(){
    setState(() {
      if( MyApp.senecaL.contains(widget.quote.quote)){
        MyApp.senecaL.remove(widget.quote.quote);

      }else if(MyApp.marcusL.contains(widget.quote.quote)){
        MyApp.marcusL.remove(widget.quote.quote);
      }else if(MyApp.epictetusL.contains(widget.quote.quote)){
        MyApp.epictetusL.remove(widget.quote.quote);
      }
      else{
        if(widget.quote.author == 'Seneca'){
          MyApp.senecaL.add(widget.quote.quote);
        }else if(widget.quote.author == 'Epictetus'){
          MyApp.epictetusL.add(widget.quote.quote);
        }else{
          MyApp.marcusL.add(widget.quote.quote);
        }
      }

    });
    addlist();
  }


  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           (QuoteCard.numbered) ? Text('${widget.no}. ${widget.quote.quote}') :Text(widget.quote.quote),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: dialogBox,
                  icon: const Icon(Icons.zoom_out_map, color: Colors.grey),

                ),


                IconButton(onPressed: buttonStateChange,
                  icon: Icon( colur() ? Icons.favorite : Icons.favorite_border_outlined,
                  color:  colur() ? Colors.red : Colors.grey),

                ),

            ]
            ),

            /*
            ListTile(
              trailing: Icon( Icons.favorite,
                  color:  colur() ? Colors.red : Colors.grey
              ),
              onTap: ButtonStateChange,

            ),
            */


          ],
        ),
      ),
    );
  }
}
