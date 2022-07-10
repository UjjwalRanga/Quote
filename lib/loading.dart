import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fav.dart';
import 'main.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Future<void> sett() async {
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();

    final SharedPreferences prefs = await pref;
    List<String>? l1 =prefs.getStringList('marcus');

    List<String>? l2 = prefs.getStringList('seneca');

    List<String>? l3 = prefs.getStringList('epictetus');

    String? tnow = prefs.getString('time');

    if(tnow != null){
      MyApp.Tnow = tnow;
    }

    if(l1 != null){
      for(int i=0;i<l1.length;i++){
        MyApp.marcusL.add(l1[i]);
        Fav.savedQuote.add(Quote(author: 'Marcus Aurelius',quote: MyApp.marcusL[i]));
      }

    }
    if(l2 != null){
      for(int i=0;i<l2.length;i++){
        MyApp.senecaL.add(l2[i]);
        Fav.savedQuote.add(Quote(author: 'Seneca',quote: MyApp.senecaL[i]));
      }
    }
    if(l3 != null){
      for(int i=0;i<l3.length;i++){
        MyApp.epictetusL.add(l3[i]);
        Fav.savedQuote.add(Quote(author: 'Epictetus',quote: MyApp.epictetusL[i]));
      }
    }

    Navigator.pushReplacementNamed(context,'/home');
  }

  @override
  void initState(){
    super.initState();
    sett();

  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body:  Center(child: SpinKitWave(
        color: Colors.black,
        size: 50.0,
      ),
      ),
    );
  }
}
