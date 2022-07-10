// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:quote/loading.dart';
import 'package:quote/push_notifications.dart';
import 'package:quote/quote_card.dart';
import 'package:quote/special_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fav.dart';
import 'dart:math';

void main() {
  runApp(  MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context)=>const Loading(),
      '/home' : (context)=>const MyApp(),
      '/fav' : (context)=>Fav(),
      '/special' : (context)=>const SpecialCard(),
    },
    debugShowCheckedModeBanner: false,

  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static  List<String> marcusL = [];
  static  List<String> senecaL = [];
  static  List<String> epictetusL = [];
  static  String Tnow = '';
  static bool shuffle = true;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool showValue = false;
  @override
  void initState(){
    super.initState();
    PushNotification.init(true);
    listenNotification();
  }
  void listenNotification() => PushNotification.onNotification.stream.listen(onClickNotification);

  void onClickNotification(String? payload){
    if(payload![0] =='M'){
      SpecialCard.quote.quote = payload.substring(15,payload.length);
      SpecialCard.quote.author = payload.substring(0,15);
    }else if(payload[0] =='S'){
      SpecialCard.quote.quote = payload.substring(6,payload.length);
      SpecialCard.quote.author = payload.substring(0,6);
    }else{
      SpecialCard.quote.quote = payload.substring(9,payload.length);
      SpecialCard.quote.author = payload.substring(0,9);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SpecialCard(),
    ));

  }

  Future<void> addTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('time',time);
  }



  void clock() async {

      TimeOfDay? pickedTime =  await showTimePicker(
        initialTime: (MyApp.Tnow == '') ? TimeOfDay.now() : TimeOfDay(hour: int.parse(MyApp.Tnow.substring(0,2)), minute:  int.parse(MyApp.Tnow.substring(3,5))),
        context: context,

      );

      if(pickedTime != null ){
        print(DateTime.now());
        print('Time :  ${MyApp.Tnow.substring(0,2)}  +   ${MyApp.Tnow.substring(3,5)}');

        print(pickedTime.format(context));   //output 10:51 PM

        DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());

        print(parsedTime); //output 1970-01-01 22:53:00.000

        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

        print(formattedTime); //output 14:59:00
        addTime(formattedTime);
        MyApp.Tnow = formattedTime;
      }else{
        print("Time is not selected");
      }
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        //backgroundColor: Colors.grey[800],
        appBar: AppBar(

          backgroundColor: Colors.black,
          title:  const Text("Quotes"),

          actions: [


            IconButton(onPressed: () {

              /*
              sendNotification(
              body:  SpecialCard.quote.quote,
              title:  SpecialCard.quote.author
              );
              */

              SpecialCard.quote = Data.epictetus[5];
              PushNotification.showNotification(
                title: SpecialCard.quote.author,
                body: SpecialCard.quote.quote,
                schedule: DateTime.now().add(const Duration(seconds: 10)),
                payload: '${SpecialCard.quote.author}${SpecialCard.quote.quote}',
              );
              },icon: const Icon(Icons.notifications_active_rounded,),),

            IconButton(onPressed: clock ,icon: const Icon(Icons.access_time_rounded,),),


            IconButton(onPressed: (){
              setState((){
                var dt = DateTime(DateTime.now().year,1,1);
                var currentDate = DateTime.now();
                int n = currentDate.difference(dt).inDays;
                print('Day: $n');
                SpecialCard.quote = Data.marcus[5];
                Navigator.pushNamed(context, '/special');
              });
            },icon: const Icon(Icons.today,),),

            IconButton(onPressed: (){
                setState((){  Navigator.pushNamed(context, '/fav');   });
                },icon: const Icon(Icons.favorite,),),


            PopupMenuButton<int>(
              itemBuilder: (context) => [

                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon( (MyApp.shuffle) ? Icons.done : Icons.close,color: Colors.black),
                      const SizedBox(width: 10,),
                      const Text("Shuffled"),
                    ],
                  ),
                  onTap: (){
                        setState(() {
                          if(MyApp.shuffle) {
                            MyApp.shuffle = false;
                          }else{
                            MyApp.shuffle = true;
                          }
                      });

                  },
                ),

                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children:  [
                      Icon( (QuoteCard.numbered) ? Icons.done : Icons.close,color: Colors.black,),
                      SizedBox(width: 10,),
                      Text("Show Number")
                    ],
                  ),
                  onTap: (){
                    setState(() {
                      if(QuoteCard.numbered) {
                        QuoteCard.numbered = false;
                      }else{
                        QuoteCard.numbered = true;
                      }
                    });

                  },
                ),
              ],
              color: Colors.white,
              elevation: 3,
            ),
          ],

          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
                Tab(text: "Seneca",),
                Tab(text: "Marcus Aurelius",),
                Tab(text: "Epictetus",),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            buildPage(Data.seneca),
            buildPage(Data.marcus),
            buildPage(Data.epictetus)
          ],
      
          
        ),


      ),
    );
  }


}

class Quote {

  late String quote;
  late String author;
  Quote({required this.author,required this.quote});
}

Widget buildPage(List<Quote> list){
      int i = 0;
      if(MyApp.shuffle) list.shuffle(Random());
      return ListView(children: list.map((e) => QuoteCard(quote: e,no: ++i,)).toList(),);
}

class Data {

  static List<Quote> marcus = [
    Quote(author:  "Marcus Aurelius", quote: "Waste no more time arguing what a good man should be. Be One."),
    Quote(author:  "Marcus Aurelius", quote: "You could leave life right now. Let that determine what you do and say and think."),
    Quote(author:  "Marcus Aurelius", quote: "Be tolerant with others and strict with yourself."),
    Quote(author:  "Marcus Aurelius", quote: "You have power over your mind - not outside events. Realize this, and you will find strength."),
    Quote(author:  "Marcus Aurelius", quote: "When you arise in the morning, think of what a precious privilege it is to be alive - to breathe, to think, to enjoy, to love."),
    Quote(author:  "Marcus Aurelius", quote: "The happiness of your life depends upon the quality of your thoughts."),
    Quote(author:  "Marcus Aurelius", quote: "Everything we hear is an opinion, not a fact. Everything we see is a perspective, not the truth."),
    Quote(author:  "Marcus Aurelius", quote: "It never ceases to amaze me: we all love ourselves more than other people, but care more about their opinions than our own."),
    Quote(author:  "Marcus Aurelius", quote: "The object of life is not to be on the side of the majority, but to escape finding oneself in the ranks of the insane."),
    Quote(author:  "Marcus Aurelius", quote: "The opinion of 10,000 men is of no value if none of them know anything about the subject."),
    Quote(author:  "Marcus Aurelius", quote: "Think of all the years passed by in which you said to yourself \"I'll do it tomorrow,\" and how the gods have again and again granted you periods of grace of which you have not availed yourself. It is time to realize that you are a member of the Universe, that you are born of Nature itself, and to know that a limit has been set to your time. Use every moment wisely, to perceive your inner refulgence, or 'twill be gone and nevermore within your reach."),
    Quote(author:  "Marcus Aurelius", quote: "If you are distressed by anything external, the pain is not due to the thing itself, but to your estimate of it; and this you have the power to revoke at any moment."),
    Quote(author:  "Marcus Aurelius", quote: "Live a good life. If there are gods and they are just, then they will not care how devout you have been, but will welcome you based on the virtues you have lived by. If there are gods, but unjust, then you should not want to worship them. If there are no gods, then you will be gone, but will have lived a noble life that will live on in the memories of your loved ones."),
    Quote(author:  "Marcus Aurelius", quote: "The things you think about determine the quality of your mind. Your soul takes on the color of your thoughts."),
    Quote(author:  "Marcus Aurelius", quote: "You always own the option of having no opinion. There is never any need to get worked up or to trouble your soul about things you can't control. These things are not asking to be judged by you. Leave them alone."),
    Quote(author:  "Marcus Aurelius", quote: "Say to yourself in the early morning: I shall meet today ungrateful, violent, treacherous, envious, uncharitable men. All of these things have come upon them through ignorance of real good and ill... I can neither be harmed by any of them, for no man will involve me in wrong, nor can I be angry with my kinsman or hate him; for we have come into the world to work together."),
    Quote(author:  "Marcus Aurelius", quote: "Whenever you are about to find fault with someone, ask yourself the following question: What fault of mine most nearly resembles the one I am about to criticize?"),
    Quote(author:  "Marcus Aurelius", quote: "Do not be wise in words - be wise in deeds."),
    Quote(author:  "Marcus Aurelius", quote: "Give yourself a gift: the present moment."),
    Quote(author:  "Marcus Aurelius", quote: "What we do in life ripples in eternity."),
    Quote(author:  "Marcus Aurelius", quote: "Why should we feel anger at the world? As if the world would notice?"),
    Quote(author:  "Marcus Aurelius", quote: "Very little is needed to make a happy life; it is all within yourself, in your way of thinking."),
    Quote(author:  "Marcus Aurelius", quote: "It is not death that a man should fear, but he should fear never beginning to live."),
    Quote(author:  "Marcus Aurelius", quote: "Death smiles at us all, all a man can do is smile back."),
    Quote(author:  "Marcus Aurelius", quote: "Life is short. Do not forget about the most important things in our life, living for other people and doing good for them."),
    Quote(author:  "Marcus Aurelius", quote: "If someone can prove me wrong and show me my mistake in any thought or action, I shall gladly change. I seek the truth, which never harmed anyone: the harm is to persist in one's own self-deception and ignorance."),
    Quote(author:  "Marcus Aurelius", quote: "Adapt yourself to the life you have been given; and truly love the people with whom destiny has surrounded you."),
    Quote(author:  "Marcus Aurelius", quote: "The happiness of those who want to be popular depends on others; the happiness of those who seek pleasure fluctuates with moods outside their control; but the happiness of the wise grows out of their own free acts."),
    Quote(author:  "Marcus Aurelius", quote: "I'm going to be meeting with people today who talk too much - people who are selfish, egotistical, ungrateful. But I won't be surprised or disturbed, for I can't imagine a world without such people."),
    Quote(author:  "Marcus Aurelius", quote: "Do not indulge in dreams of having what you have not, but reckon up the chief of the blessings you do possess, and then thankfully remember how you would crave for them if they were not yours."),
    Quote(author:  "Marcus Aurelius", quote: "The impediment to action advances action. What stands in the way becomes the way."),
    Quote(author:  "Marcus Aurelius", quote: "The best revenge is not to be like your enemy."),
    Quote(author:  "Marcus Aurelius", quote: "Our life is what our thoughts make it."),
    Quote(author:  "Marcus Aurelius", quote: "Live your life as if you are ready to say goodbye to it at any moment, as if the time left for you were some pleasant surprise."),
    Quote(author:  "Marcus Aurelius", quote: "Our anger and annoyance are more detrimental to us than the things themselves which anger or annoy us."),
    Quote(author:  "Marcus Aurelius", quote: "Nothing that goes on in anyone else's mind can harm you."),
    Quote(author:  "Marcus Aurelius", quote: "Bear in mind that the measure of a man is the worth of the things he cares about."),
    Quote(author:  "Marcus Aurelius", quote: "Waste no more time arguing what a good man should be. Be one."),
    Quote(author:  "Marcus Aurelius", quote: "Whoever values peace of mind and the health of the soul will live the best of all possible lives."),

  ];

  static List<Quote> seneca = [

    Quote(author:  "Seneca", quote: "We are more often frightened than hurt; and we suffer more in imagination than in reality."),
    Quote(author:  "Seneca", quote: "No person has the power to have everything they want, but it is in their power not to want what they don’t have, and to cheerfully put to good use what they do have."),
    Quote(author:  "Seneca", quote: "This is our big mistake: to think we look forward to death. Most of death is already gone. Whatever time has passed is owned by death."),
    Quote(author:  "Seneca", quote: "True happiness is to enjoy the present, without anxious dependence upon the future, not to amuse ourselves with either hopes or fears but to rest satisfied with what we have, which is sufficient, for he that is so, wants nothing."),
    Quote(author:  "Seneca", quote: "Luck is what happens when preparation meets opportunity."),
    Quote(author:  "Seneca", quote: "All cruelty springs from weakness."),
    Quote(author:  "Seneca", quote: "Begin at once to live, and count each separate day as a separate life."),
    Quote(author:  "Seneca", quote: "Throw me to the wolves and I will return leading the pack."),
    Quote(author:  "Seneca", quote: "As is a tale, so is life: not how long it is, but how good it is, is what matters."),
    Quote(author:  "Seneca", quote: "They lose the day in expectation of the night, and the night in fear of the dawn."),
    Quote(author:  "Seneca", quote: "Every night before going to sleep, we must ask ourselves: what weakness did I overcome today? What virtue did I acquire?"),
    Quote(author:  "Seneca", quote: "Difficulties strengthen the mind, as labor does the body."),
    Quote(author:  "Seneca", quote: "We are always complaining that our days are few, and acting as though there would be no end of them."),
    Quote(author:  "Seneca", quote: "It is not because things are difficult that we do not dare; it is because we do not dare that things are difficult."),
    Quote(author:  "Seneca", quote: "Associate with people who are likely to improve you."),
    Quote(author:  "Seneca", quote: "Man is affected not by events but by the view he takes of them."),
    Quote(author:  "Seneca", quote: "We suffer more often in imagination than in reality."),
    Quote(author:  "Seneca", quote: "You want to live but do you know how to live? You are scared of dying and tell me, is the kind of life you lead really any different from being dead?"),
    Quote(author:  "Seneca", quote: "Time heals what reason cannot."),
    Quote(author:  "Seneca", quote: "The greatest blessings of mankind are within us and within our reach. A wise man is content with his lot, whatever it may be, without wishing for what he has not."),
    Quote(author:  "Seneca", quote: "Hang on to your youthful enthusiasms — you’ll be able to use them better when you’re older."),
    Quote(author:  "Seneca", quote: "You act like mortals in all that you fear, and like immortals in all that you desire."),
    Quote(author:  "Seneca", quote: "If a man knows not to which port he sails, no wind is favorable."),
    Quote(author:  "Seneca", quote: "It is not the man who has too little, but the man who craves more, that is poor. "),
    Quote(author:  "Seneca", quote: "It is the power of the mind to be unconquerable."),
    Quote(author:  "Seneca", quote: "The bravest sight in the world is to see a great man struggling against adversity."),
    Quote(author:  "Seneca", quote: "It is not that we have so little time but that we lose so much. … The life we receive is not short but we make it so; we are not ill provided but use what we have wastefully."),
    Quote(author:  "Seneca", quote: "If you really want to escape the things that harass you, what you’re needing is not to be in a different place but to be a different person."),
    Quote(author:  "Seneca", quote: "He suffers more than necessary, who suffers before it is necessary."),
    Quote(author:  "Seneca", quote: "Wealth is the slave of the wise. The master of the fool."),
    Quote(author:  "Seneca", quote: "Until we have begun to go without them, we fail to realize how unnecessary many things are. We’ve been using them not because we needed them but because we had them."),
    Quote(author:  "Seneca", quote: "Sometimes even to live is an act of courage."),
    Quote(author:  "Seneca", quote: "Life is never incomplete if it is an honorable one. At whatever point you leave life, if you leave it in the right way, it is whole."),
    //Quote(author:  "Seneca", quote: ""),

  ];

  static List<Quote> epictetus = [
    Quote(author:  "Epictetus", quote: "If anyone tells you that a certain person speaks ill of you, do not make excuses about what is said of you but answer, \"He was ignorant of my other faults, else he would not have mentioned these alone."),
    Quote(author:  "Epictetus", quote: "Wealth consists not in having great possessions, but in having few wants."),
    Quote(author:  "Epictetus", quote: "Don't explain your philosophy. Embody it"),
    Quote(author:  "Epictetus", quote: "There is only one way to happiness and that is to cease worrying about things which are beyond the power or our will."),
    Quote(author:  "Epictetus", quote: "Man is not worried by real problems so much as by his imagined anxieties about real problems"),
    Quote(author:  "Epictetus", quote: "First say to yourself what you would be; and then do what you have to do."),
    Quote(author:  "Epictetus", quote: "If you want to improve, be content to be thought foolish and stupid."),
    Quote(author:  "Epictetus", quote: "It's not what happens to you, but how you react to it that matters."),
    Quote(author:  "Epictetus", quote: "The key is to keep company only with people who uplift you, whose presence calls forth your best."),
    Quote(author:  "Epictetus", quote: "Any person capable of angering you becomes your master; he can anger you only when you permit yourself to be disturbed by him."),
    Quote(author:  "Epictetus", quote: "Other people's views and troubles can be contagious. Don't sabotage yourself by unwittingly adopting negative, unproductive attitudes through your associations with others."),
    Quote(author:  "Epictetus", quote: "He who laughs at himself never runs out of things to laugh at."),
    Quote(author:  "Epictetus", quote: "Freedom is the only worthy goal in life. It is won by disregarding things that lie beyond our control."),
    Quote(author:  "Epictetus", quote: "Only the educated are free."),
    Quote(author:  "Epictetus", quote: "It is impossible for a man to learn what he thinks he already knows."),
    Quote(author:  "Epictetus", quote: "Circumstances don't make the man, they only reveal him to himself."),
    Quote(author:  "Epictetus", quote: "To accuse others for one's own misfortune is a sign of want of education. To accuse oneself shows that one's education has begun. To accuse neither oneself nor others shows that one's education is complete."),
    Quote(author:  "Epictetus", quote: "Nature hath given men one tongue but two ears, that we may hear from others twice as much as we speak.Nature"),
    Quote(author:  "Epictetus", quote: "People are not disturbed by things, but by the views they take of them."),
    Quote(author:  "Epictetus", quote: "I laugh at those who think they can damage me. They do not know who I am, they do not know what I think, they cannot even touch the things which are really mine and with which I live."),
    Quote(author:  "Epictetus", quote: "You are a little soul carrying around a corpse"),
    Quote(author:  "Epictetus", quote: "Attach yourself to what is spiritually superior, regardless of what other people think or do. Hold to your true aspirations no matter what is going on around you."),
    Quote(author:  "Epictetus", quote: "First learn the meaning of what you say, and then speak."),
    Quote(author:  "Epictetus", quote: "The greater the difficulty, the more glory in surmounting it. Skillful pilots gain their reputation from storms and tempests."),
    Quote(author:  "Epictetus", quote: "No man is free who is not master of himself."),
    Quote(author:  "Epictetus", quote: "He is a wise man who does not grieve for the things which he has not, but rejoices for those which he has."),
    Quote(author:  "Epictetus", quote: "Seek not the good in external things;seek it in yourselves."),
    Quote(author:  "Epictetus", quote: "Do not try to seem wise to others."),
    Quote(author:  "Epictetus", quote: "If evil be said of thee, and if it be true, correct thyself; if it be a lie, laugh at it."),
    Quote(author:  "Epictetus", quote: "Don't seek to have events happen as you wish, but wish them to happen as they do happen, and all will be well with you."),
    Quote(author:  "Epictetus", quote: "A ship should not ride on a single anchor, nor life on a single hope"),
    Quote(author:  "Epictetus", quote: "Know, first, who you are, and then adorn yourself accordingly."),
    Quote(author:  "Epictetus", quote: "Preach not to others what they should eat, but eat as becomes you and be silent."),
    Quote(author:  "Epictetus", quote: "If you would be a reader, read; if a writer, write."),
    Quote(author:  "Epictetus", quote: "Events do not just happen, but arrive by appointment."),
    Quote(author:  "Epictetus", quote: "We are not disturbed by what happens to us, but by our thoughts about what happens to us."),
    Quote(author:  "Epictetus", quote: "It is not so much what happens to you as how you think about what happens."),
    Quote(author:  "Epictetus", quote: "If you wish to be a writer, write."),
    Quote(author:  "Epictetus", quote: "Asked, Who is the rich man? Epictetus replied, ?He who is content."),
    Quote(author:  "Epictetus", quote: "I must die. Must I then die lamenting? I must be put in chains. Must I then also lament? I must go into exile. Does any man then hinder me from going with smiles and cheerfulness and contentment?"),
    Quote(author:  "Epictetus", quote: "Either God wants to abolish evil, and cannot; or he can, but does not want to."),
    Quote(author:  "Epictetus", quote: "Small-minded people blame others. Average people blame themselves. The wise see all blame as foolishness"),
    Quote(author:  "Epictetus", quote: "Know you not that a good man does nothing for appearance sake, but for the sake of having done right?"),
    Quote(author:  "Epictetus", quote: "It is better to die of hunger having lived without grief and fear, than to live with a troubled spirit, amid abundance"),
    Quote(author:  "Epictetus", quote: "Demand not that things happen as you wish, but wish them to happen as they do, and you will go on well."),
    Quote(author:  "Epictetus", quote: "-….when things seem to have reached that stage, merely say “I won’t play any longer”, and take your departure; but if you stay, stop lamenting."),
    Quote(author:  "Epictetus", quote: "No great thing is created suddenly."),
    Quote(author:  "Epictetus", quote: "Give me by all means the shorter and nobler life, instead of one that is longer but of less account!"),
    Quote(author:  "Epictetus", quote: "Men are not afraid of things, but of how they view them."),
    Quote(author:  "Epictetus", quote: "If someone speaks badly of you, do not defend yourself against the accusations, but reply; \"you obviously don't know about my other vices, otherwise you would have mentioned these as well"),
    Quote(author:  "Epictetus", quote: "Control thy passions lest they take vengence on thee. ~ Epictetus"),
    Quote(author:  "Epictetus", quote: "We must not believe the many, who say that only free people ought to be educated, but we should rather believe the philosophers who say that only the educated are free."),
    Quote(author:  "Epictetus", quote: "If you want to improve, you must be content to be thought foolish and stupid."),
    Quote(author:  "Epictetus", quote: "On the occasion of every accident that befalls you, remember to turn to yourself and inquire what power you have for turning it to use."),
    Quote(author:  "Epictetus", quote: "If any be unhappy, let him remember that he is unhappy by reason of himself alone. For God hath made all men to enjoy felicity and constancy of good."),
    Quote(author:  "Epictetus", quote: "You may fetter my leg, but Zeus himself cannot get the better of my free will."),
    Quote(author:  "Epictetus", quote: "No great thing is created suddenly, any more than a bunch of grapes or a fig. If you tell me that you desire a fig, I answer that there must be time. Let it first blossom, then bear fruit, then ripen."),
    Quote(author:  "Epictetus", quote: "Difficulty shows what men are."),
    Quote(author:  "Epictetus", quote: "There is but one way to tranquility of mind and happiness, and that is to account no external things thine own, but to commit all to God."),
    Quote(author:  "Epictetus", quote: "It is our attitude toward events, not events themselves, which we can control. Nothing is by its own nature calamitous -- even death is terrible only if we fear it."),
    Quote(author:  "Epictetus", quote: "Imagine for yourself a character, a model personality, whose example you determine to follow, in private as well as in public."),
    Quote(author:  "Epictetus", quote: "No man is free until he s a master of himself!!"),
    Quote(author:  "Epictetus", quote: "-Who are those people by whom you wish to be admired? Are they not these whom you are in the habit of saying that they are mad? What then? Do you wish to be admired by the mad?"),
    Quote(author:  "Epictetus", quote: "Whoever is going to listen to the philosophers needs a considerable practice in listening."),
    Quote(author:  "Epictetus", quote: "When a youth was giving himself airs in the Theatre and saying, 'I am wise, for I have conversed with many wise men,' Epictetus replied, 'I too have conversed with many rich men, yet I am not rich!’."),
    Quote(author:  "Epictetus", quote: "The essence of philosophy is that a man should so live that his happiness shall depend as little as possible on external things."),
    Quote(author:  "Epictetus", quote: "If you seek Truth, you will not seek to gain a victory by every possible means; and when you have found Truth, you need not fear being defeated."),
    Quote(author:  "Epictetus", quote: "We have two ears and one mouth so that we can listen twice as much as we speak."),
    Quote(author:  "Epictetus", quote: "Your happiness depends on three things, all of which are within your power: your will, your ideas concerning the events in which you are involved, and the use you make of your ideas"),
    Quote(author:  "Epictetus", quote: "Don't live by your own rules, but in harmony with nature"),
    Quote(author:  "Epictetus", quote: "Is freedom anything else than the right to live as we wish? Nothing else."),
    Quote(author:  "Epictetus", quote: "It is better to do wrong seldom and to own it, and to act right for the most part, than seldom to admit that you have done wrong and to do wrong often."),
    Quote(author:  "Epictetus", quote: "In banquets remember that you entertain two guests, body and soul: and whatever you shall have given to the body you soon eject: but what you shall have given to the soul, you keep always."),
    Quote(author:  "Epictetus", quote: "Epictetus being asked how a man should give pain to his enemy answered, By preparing himself to live the best life that he can."),
    Quote(author:  "Epictetus", quote: "What really frightens and dismays us is not external events themselves, but the way in which we think about them. It is not things that disturb us, but our interpretation of their significance."),
    Quote(author:  "Epictetus", quote: "What concerns me is not the way things are, but the way people think things are."),
    Quote(author:  "Epictetus", quote: "Men are disturbed not by the things that happen, but by their opinion of the things that happen."),
    Quote(author:  "Epictetus", quote: "No one is ever unhappy because of someone else."),
    Quote(author:  "Epictetus", quote: "[Do not get too attached to life] for it is like a sailor's leave on the shore and at any time, the captain may sound the horn, calling you back to eternal darkness."),
    Quote(author:  "Epictetus", quote: "For it is not death or pain that is to be feared, but the fear of pain or death."),
    Quote(author:  "Epictetus", quote: "If thy brother wrongs thee, remember not so much his wrong-doing, but more than ever that he is thy brother."),
    Quote(author:  "Epictetus", quote: "Crows pick out the eyes of the dead, when the dead have no longer need of them; but flatterers mar the soul of the living, and her eyes they blind."),
    Quote(author:  "Epictetus", quote: "Everyone's life is a warfare, and that long and various."),
    Quote(author:  "Epictetus", quote: "Never say that I have taken it, only that I have given it back."),
    Quote(author:  "Epictetus", quote: "Those who are well constituted in the body endure both heat and cold: and so those who are well constituted in the soul endure both anger and grief and excessive joy and the other affects."),
    Quote(author:  "Epictetus", quote: "Keep the prospect of death, exile and all such apparent tragedies before you every day – especially death – and you will never have an abject thought, or desire anything to excess."),
    Quote(author:  "Epictetus", quote: "No person is free who is not master of himself."),
    Quote(author:  "Epictetus", quote: "Whoever then would be free, let him wish for nothing, let him decline nothing, which depends on others; else he must necessarily be a slave."),
    Quote(author:  "Epictetus", quote: "The philosopher's school, ye men, is a surgery: you ought not to go out of it with pleasure, but with pain. For you are not in sound health when you enter."),
    Quote(author:  "Epictetus", quote: "An ignorant person is inclined to blame others for his own misfortune. To blame oneself is proof of progress. But the wise man never has to blame another or himself."),
    Quote(author:  "Epictetus", quote: "For sheep don't throw up the grass to show the shepherds how much they have eaten; but, inwardly digesting their food, they outwardly produce wool and milk."),
    Quote(author:  "Epictetus", quote: "Be free from grief not through insensibility like the irrational animals, nor through want of thought like the foolish, but like a man of virtue by having reason as the consolation of grief."),
    Quote(author:  "Epictetus", quote: "Freedom is not procured by a full enjoyment of what is desired, but by controlling the desire."),
    Quote(author:  "Epictetus", quote: "As a man, casting off worn out garments taketh new ones, so the dweller in the body, entereth into ones that are new."),
    Quote(author:  "Epictetus", quote: "A city is not adorned by external things, but by the virtue of those who dwell in it."),
    Quote(author:  "Epictetus", quote: "Men are disturbed not by the things which happen, but by the opinion about the things."),
    Quote(author:  "Epictetus", quote: "What saith Antisthenes? Hast thou never heard?— It is a kingly thing, O Cyrus, to do well and to be evil spoken of."),
    Quote(author:  "Epictetus", quote: "Men are disturbed not by the things which happen, but by the opinions about the things:"),
    Quote(author:  "Epictetus", quote: "Nothing great comes into being all at once, for that is not the case even with a bunch of grapes or a fig. If you tell me now, ‘I want a fig,’ I’ll reply, ‘That takes time."),
    Quote(author:  "Epictetus", quote: "Take care not to hurt the ruling faculty of your mind. If you were to guard against this in every action, you should enter upon those actions more safely."),




  ];


}