import 'package:flutter/material.dart';
import 'package:music_player/Screens/currently_playing.dart';
import 'package:music_player/Screens/dashboard.dart';
import 'package:provider/provider.dart';

import 'Classes/audio_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AudioPlayerProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Dashboard()),
    );
  }
}
