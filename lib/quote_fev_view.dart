import 'package:flutter/material.dart';
import 'main.dart';


class QuoteFevCard extends StatefulWidget {
  final Quote quote;

    QuoteFevCard( {required this.quote});

  @override
  State<QuoteFevCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteFevCard> {



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
            Text(widget.quote.quote),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('- ${widget.quote.author}'),
              ],
            )


          ],
        ),
      ),
    );
  }
}
