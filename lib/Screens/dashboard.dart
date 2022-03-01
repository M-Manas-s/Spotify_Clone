import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/Classes/audio_player.dart';
import 'package:music_player/Classes/home_tabs.dart';
import 'package:music_player/Constants/constants.dart';
import 'package:music_player/Constants/music_data.dart';
import 'package:music_player/Screens/currently_playing.dart';
import 'package:music_player/Widgets/HomeScreen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int ci;

  @override
  Widget build(BuildContext context) {
    ci = Provider.of<AudioPlayer>(context, listen: true).currently_playing;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        // height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "Assets/Images/" + tracks[ci].image,
              ),
              fit: BoxFit.fitHeight,
              alignment: tracks[ci].albumAlign),
        ),
        child: ChangeNotifierProvider(
          create: (BuildContext context) => HomeTab(),
          builder: (context, widget) {
            return Column(
              children: [
                Expanded(
                    flex: 11,
                    child: Container(
                      height: size.height,
                      width: size.width,
                      color: Colors.black,
                    )),
                NavBarAndPlaying(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NavBarAndPlaying extends StatefulWidget {
  const NavBarAndPlaying({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBarAndPlaying> createState() => _NavBarAndPlayingState();
}

class _NavBarAndPlayingState extends State<NavBarAndPlaying> {
  @override
  Widget build(BuildContext context) {
    int ci = Provider.of<AudioPlayer>(context, listen: true).currently_playing;
    int tab = Provider.of<HomeTab>(context, listen: true).tab;
    Size size = MediaQuery.of(context).size;
    return Expanded(
      flex: 3,
      child: Container(
          width: size.width,
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: BuildCurrentlyPlaying(size: size, ci: ci),
              ),
              Expanded(
                  flex: 5,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 40.0,
                        sigmaY: 40.0,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.04, left: size.width * 0.03, right: size.width * 0.03),
                        child: buildNavBar(context, size, tab),
                      ),
                    ),
                  )),
            ],
          )),
    );
  }

  Row buildNavBar(BuildContext context, Size size, int tab) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onPanDown: (var x) => Provider.of<HomeTab>(context, listen: false).change(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.015, child: tab == 0 ? Icon(Icons.maximize, size: 30, color: kGreen) : Container()),
              Icon(
                Icons.home_outlined,
                color: tab == 0 ? kGreen : Colors.grey,
                size: 30,
              ),
            ],
          ),
        ),
        GestureDetector(
          onPanDown: (var x) => Provider.of<HomeTab>(context, listen: false).change(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.015, child: tab == 1 ? Icon(Icons.maximize, size: 30, color: kGreen) : Container()),
              Icon(
                Icons.search,
                color: tab == 1 ? kGreen : Colors.grey,
                size: 30,
              ),
            ],
          ),
        ),
        GestureDetector(
          onPanDown: (var x) => Provider.of<HomeTab>(context, listen: false).change(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.015, child: tab == 2 ? Icon(Icons.maximize, size: 30, color: kGreen) : Container()),
              Icon(
                Icons.headphones_outlined,
                color: tab == 2 ? kGreen : Colors.grey,
                size: 30,
              ),
            ],
          ),
        ),
        GestureDetector(
          onPanDown: (var x) => Provider.of<HomeTab>(context, listen: false).change(3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.015, child: tab == 3 ? Icon(Icons.maximize, size: 30, color: kGreen) : Container()),
              Icon(
                Icons.person_outline,
                color: tab == 3 ? kGreen : Colors.grey,
                size: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuildCurrentlyPlaying extends StatefulWidget {
  const BuildCurrentlyPlaying({
    Key? key,
    required this.size,
    required this.ci,
  }) : super(key: key);

  final Size size;
  final int ci;

  @override
  State<BuildCurrentlyPlaying> createState() => _BuildCurrentlyPlayingState();
}

class _BuildCurrentlyPlayingState extends State<BuildCurrentlyPlaying> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18.0,
          sigmaY: 18.0,
        ),
        child: GestureDetector(
          onVerticalDragUpdate: (var x) {
            // if (x.delta.dy < -3) {
            //   log(x.delta.dy.toString());
            //   Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => const CurrentlyPlaying()));
            // }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.035, vertical: widget.size.height * 0.005),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanDown: (var x) {
                    Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => const CurrentlyPlaying()));
                  },
                  child: Row(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            child: Image.asset("Assets/Images/" + tracks[widget.ci].image),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          SizedBox(
                            width: widget.size.width * 0.03,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tracks[widget.ci].name,
                                style: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: widget.size.height * 0.004,
                              ),
                              Text(
                                tracks[widget.ci].artist,
                                style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanDown: (var x) {
                      Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => const CurrentlyPlaying()));
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: kGreen,
                      size: 30,
                    ),
                    SizedBox(
                      width: widget.size.width * 0.04,
                    ),
                    GestureDetector(
                      onPanDown: (var x) => Provider.of<AudioPlayer>(context, listen: false).toggle(),
                      child: Stack(children: [
                        Center(
                          child: SizedBox(
                            height: widget.size.height * 0.055,
                            width: widget.size.height * 0.055,
                            child: CircularProgressIndicator(
                              value: 0.30,
                              color: kGreen,
                              backgroundColor: Colors.grey,
                              strokeWidth: 2.25,
                            ),
                          ),
                        ),
                        Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  !Provider.of<AudioPlayer>(context, listen: true).playing ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white,
                                  size: 33,
                                )))
                      ]),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
