import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/Classes/audio_player.dart';
import 'package:music_player/Classes/music.dart';
import 'package:music_player/Constants/constants.dart';
import 'package:music_player/Constants/music_data.dart';
import 'package:provider/provider.dart';

class CurrentlyPlaying extends StatefulWidget {

  const CurrentlyPlaying({Key? key}) : super(key: key);

  @override
  _CurrentlyPlayingState createState() => _CurrentlyPlayingState();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  late Music music;

  @override
  Widget build(BuildContext context) {
    music = tracks[Provider
        .of<AudioPlayer>(context, listen: true)
        .currently_playing];
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "Assets/Images/" + music.image,
              ),
              fit: BoxFit.fitHeight, alignment: music.albumAlign),
        ),
        child: Column(
          children: [
            buildTopIcons(size),
            ControlArea(music: music),
          ],
        ),
      ),
    );
  }

  Expanded buildTopIcons(Size size) {
    return Expanded(
        flex: 9,
        child: Container(
          padding: EdgeInsets.all(size.width * 0.05),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 25), onPressed: () {
                      Navigator.pop(context);
                    },),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.share, color: Colors.white, size: 28),
                        SizedBox(width: size.width * 0.04),
                        const Icon(Icons.more_vert, color: Colors.white, size: 35),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class ControlArea extends StatefulWidget {

  final Music music;

  const ControlArea({
    Key? key, required this.music,
  }) : super(key: key);

  @override
  State<ControlArea> createState() => _ControlAreaState();
}

class _ControlAreaState extends State<ControlArea> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Expanded(
      flex: 5,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8.0,
            sigmaY: 8.0,
          ),
          child: Container(
            color: Colors.black.withOpacity(0.45),
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      buildTitleArea(size, widget.music),
                      buildSlider(widget.music),
                    ],
                  ),
                  buildButtons(size, Provider
                      .of<AudioPlayer>(context, listen: true)
                      .playing),
                  SizedBox(height: size.height * 0.02,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildButtons(Size size, bool playing) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.shuffle, color: Colors.white, size: 25,),
          Row(
            children: [
              IconButton(icon: const ImageIcon(AssetImage("Assets/Icons/back.png"), color: Colors.white, size: 32,), padding: const EdgeInsets.all(0), onPressed: () {
                Provider.of<AudioPlayer>(context, listen: false).changePlaying(false);
              },),
              SizedBox(width: size.width * 0.05,),
              IconButton(onPressed: () => Provider.of<AudioPlayer>(context, listen: false).toggle(),
                icon:
                Icon(!playing ? Icons.play_circle : Icons.pause_circle, color: kGreen), padding: const EdgeInsets.all(0), iconSize: 86,),
              SizedBox(width: size.width * 0.05,),
              IconButton(icon: const ImageIcon(AssetImage("Assets/Icons/next.png"), color: Colors.white, size: 32), padding: const EdgeInsets.all(0), onPressed: () {
                Provider.of<AudioPlayer>(context, listen: false).changePlaying(true);
              },),
            ],
          ),
          const Icon(Icons.loop, color: Colors.white, size: 25),
        ],
      ),
    );
  }

  SliderTheme buildSlider(Music music) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        trackShape: CustomTrackShape(),
        thumbColor: kGreen,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
            child: Slider(
              value: 121.0,
              min: 0.0,
              max: 224.0,
              divisions: 100,
              activeColor: kGreen,
              inactiveColor: Colors.grey,
              onChanged: (double value) {},
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "2:01",
                style: kStandardWhite.copyWith(fontSize: 12),
              ),
              Text(
                (music.duration ~/ 60).toString() + ":" + (music.duration % 60).toString(),
                style: kStandardWhite.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row buildTitleArea(Size size, Music music) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              music.name,
              style: const TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: size.height * 0.007,
            ),
            Text(
              music.artist,
              style: const TextStyle(color: Colors.grey, fontSize: 17, fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        Icon(
          Icons.favorite,
          color: kGreen,
          size: 30,
        )
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double? trackHeight = 3;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + 20;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
