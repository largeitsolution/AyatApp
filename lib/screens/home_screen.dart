import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:golpo/model/music_model.dart';
import 'package:golpo/provider/view_model_provider.dart';
import 'package:golpo/screens/player_details.dart';
import 'package:golpo/widgets/custom_text.dart';
import 'package:golpo/widgets/music_card.dart';
import 'package:provider/provider.dart';
late AudioHandler _audioHandler;
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ViewModelProvider viewModelProvider;
 
  List<MusicModel> musicList = [
    MusicModel(
        title: "Allah Amr Rob",
        lebel: "Kazi Nazrul",
        imageUrl:
            "https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg",
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3"),
    MusicModel(
        title: "Allah Amr Sob",
        lebel: "Sofiya Kamal",
        imageUrl: "https://tinypng.com/images/social/website.jpg",
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3"),
    MusicModel(
        title: "Allah Amr Malik",
        lebel: "Begum Requya",
        imageUrl: "https://static.addtoany.com/images/dracaena-cinnabari.jpg",
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3")
  ];

  MusicModel? selectedMuisc;
  bool isNavbarShow = false;
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.PLAYING;
  Duration position = new Duration();
  Duration musicLength = new Duration();
  int timeProgress = 0;
  int audioDuration = 0;
  int globalMusicIndex = 0;
  Random rnd = new Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModelProvider = Provider.of<ViewModelProvider>(context, listen: false);

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        audioPlayerState = state;
        print('state: $audioPlayerState');
        if (audioPlayerState == PlayerState.COMPLETED &&
            viewModelProvider.isLoop == false &&
            (viewModelProvider.globalIndex <
                viewModelProvider.musicListProvider.length - 1)) {
          // globalMusicIndex++;
          viewModelProvider.globalIndex++;
          viewModelProvider.setGlobalIndex(viewModelProvider.globalIndex);
          // setState(() {});
          // selectedMuisc = musicList[globalMusicIndex];
          viewModelProvider.selectedMusicProvider = viewModelProvider
              .musicListProvider[viewModelProvider.globalIndex];
          viewModelProvider
              .setSelectedMusic(viewModelProvider.selectedMusicProvider);
          playMusic();
          // setState(() {});
          print(viewModelProvider.globalIndex);
        } else if (audioPlayerState == PlayerState.COMPLETED &&
            viewModelProvider.isLoop == false &&
            (viewModelProvider.globalIndex ==
                viewModelProvider.musicListProvider.length - 1)) {
          viewModelProvider.globalIndex = 0;
          viewModelProvider.setGlobalIndex(viewModelProvider.globalIndex);
          // setState(() {});
          // selectedMuisc = musicList[globalMusicIndex];
          viewModelProvider.selectedMusicProvider = viewModelProvider
              .musicListProvider[viewModelProvider.globalIndex];
          viewModelProvider
              .setSelectedMusic(viewModelProvider.selectedMusicProvider);
          playMusic();
        } else if (audioPlayerState == PlayerState.COMPLETED &&
            viewModelProvider.isLoop == true) {
          playMusic();
        } else if (audioPlayerState == PlayerState.COMPLETED &&
            viewModelProvider.isLoop == false &&
            viewModelProvider.isRandom == true) {
          viewModelProvider.selectedMusicProvider = viewModelProvider
              .musicListProvider[viewModelProvider.globalIndex];
          viewModelProvider
              .setSelectedMusic(viewModelProvider.selectedMusicProvider);
          playMusic();
        }
      });
    });

    /// Optional
    audioPlayer.setUrl(viewModelProvider.selectedMusicProvider == null
        ? "none"
        : viewModelProvider.selectedMusicProvider!
            .url); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        // audioDuration = duration.inSeconds;
        viewModelProvider.totalDuration = duration.inSeconds;
        // viewModelProvider.setTotalDuration(viewModelProvider.totalDuration);
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) async {
      setState(() {
        // timeProgress = position.inSeconds;
        viewModelProvider.prog = position.inSeconds;
        viewModelProvider.setProg(viewModelProvider.prog);
      });
    });
  }

  /// Compulsory
  @override
  void dispose() {
    audioPlayer.release();
     audioPlayer.dispose();
    audioPlayer.notificationService;
   
    super.dispose();
  }

  /// Compulsory
  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    // await audioPlayer.play(selectedMuisc!.url);
    await audioPlayer.play(viewModelProvider.selectedMusicProvider!.url);
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
    print(newPos); // Jumps to the given position within the audio file
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          backgroundColor: Colors.black45,
          elevation: 0,
          title: CustomText(
            text: "Recently played",
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                size: 26,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.schedule_outlined,
                size: 26,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                size: 26,
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MusicCard(
            containerHeight: 100,
            containerWidth: 80,
            title: "The Power of",
            lebel: "Positive Thinking",
            url: "ferfer",
            imageUrl:
                "https://static.remove.bg/remove-bg-web/5cc729f2c60683544f035949b665ce17223fd2ec/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg",
            imageHeight: 60,
            imagewidth: 80,
            textColor: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          CustomText(
            text: "Made For Account",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 10,
          ),
          MusicCard(
            containerHeight: 125,
            containerWidth: 100,
            title: "The Power of",
            lebel: "Positive Thinking",
            url: "dfergf",
            imageUrl:
                "https://static.remove.bg/remove-bg-web/5cc729f2c60683544f035949b665ce17223fd2ec/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg",
            imageHeight: 90,
            imagewidth: 100,
            textColor: Colors.grey,
          ),
          SizedBox(
            height: 20,
          ),
          CustomText(
            text: "Recommended Radio",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 125,
            child: ListView.builder(
                itemCount: viewModelProvider.musicListProvider.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemExtent: 125,
                physics: ScrollPhysics(),
                itemBuilder: (context, globalMusicIndex) {
                  return GestureDetector(
                    onTap: () {
                      viewModelProvider.globalIndex = globalMusicIndex;
                      viewModelProvider
                          .setGlobalIndex(viewModelProvider.globalIndex);
                      viewModelProvider.selectedMusicProvider =
                          viewModelProvider.musicListProvider[
                              viewModelProvider.globalIndex];
                    
                      viewModelProvider.setSelectedMusic(
                          viewModelProvider.selectedMusicProvider);
                      isNavbarShow = true;
                     
                      playMusic();
                      setState(() {});
                    },
                    child: MusicCard(
                      containerHeight: 125,
                      containerWidth: 90,
                      title: viewModelProvider
                          .musicListProvider[globalMusicIndex].title,
                      lebel: viewModelProvider
                          .musicListProvider[globalMusicIndex].lebel,
                      imageUrl: viewModelProvider
                          .musicListProvider[globalMusicIndex].imageUrl,
                      url: viewModelProvider
                          .musicListProvider[globalMusicIndex].url,
                      imageHeight: 80,
                      imagewidth: 90,
                      textColor: Colors.grey,
                    ),
                  );
                }),
          )
        ],
          ),
        ),
        bottomNavigationBar: isNavbarShow == false
            ? Container(
                height: 50,
              )
            : GestureDetector(
                onTap: () {
 
                  showModalBottomSheet(
                      useRootNavigator: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Container(
                          child: buildPlayer(),
                        );
                      });
                },
                child: Consumer<ViewModelProvider>(
                  builder: ((context, viewModelProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.greenAccent,
                        ),
                        child: Column(
                          children: [
                         
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(height: 70,width: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(8),bottomLeft:Radius.circular(8) ),
                                        child: Image.network(
                                          // selectedMuisc!.imageUrl,
                                          viewModelProvider
                                              .selectedMusicProvider!.imageUrl,
                                         fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        CustomText(
                                          // text: selectedMuisc!.title,
                                          text: viewModelProvider
                                              .selectedMusicProvider!.title,
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomText(
                                          // text: selectedMuisc!.lebel,
                                          text: viewModelProvider
                                              .selectedMusicProvider!.lebel,
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        audioPlayerState == PlayerState.PLAYING
                                            ? pauseMusic()
                                            : playMusic();
                                      },
                                      child: Icon(
                                        audioPlayerState == PlayerState.PLAYING
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),


                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
      ),
    );
  }

  Widget buildPlayer() {SizedBox(height: 100);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Consumer<ViewModelProvider>(
      builder: (context, viewModelProvider, child) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  centerTitle: true,
                  toolbarHeight: 120,
                  backgroundColor: Colors.black,
                  elevation: 0.0,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.expand_more,
                        color: Colors.white,
                        size: 26,
                      )),
                  title: Column(
                    children: [
                      CustomText(
                        text: viewModelProvider.selectedMusicProvider!.title,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      CustomText(
                        text: viewModelProvider.selectedMusicProvider!.lebel,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_vert,
                        size: 26,
                      ),
                    )
                  ],
                ),
                body: SafeArea(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Image.network(
                        viewModelProvider.selectedMusicProvider!.imageUrl,
                        height: height * 0.4,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                 viewModelProvider
                                    .selectedMusicProvider!.title,
                                // color: Colors.white,
                                // fontSize: 16,
                                // fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                text: viewModelProvider
                                    .selectedMusicProvider!.lebel,
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border_outlined,
                                size: 30,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                     
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModelProvider
                                .getTimeString(viewModelProvider.prog),
                            style: TextStyle(color: Colors.white),
                          ),
                          Container(
                            width: width * 0.7,
                            height: 5,
                            child: Slider.adaptive(
                              value: viewModelProvider.prog.toDouble(),
                              max: viewModelProvider.totalDuration.toDouble(),
                              onChanged: (value) {
                             
                                seekToSec(value.toInt());
                              
                              },
                              inactiveColor: Colors.grey,
                              activeColor: Colors.white,
                            ),
                          ),
                
                             Text(
                            viewModelProvider
                                .getTimeString(viewModelProvider.totalDuration-viewModelProvider.prog),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                              
                                if (viewModelProvider.isRandom == false) {
                                  viewModelProvider.isRandom = true;
                                  viewModelProvider.setIsRandom(true);
                                  int randomIndex = rnd.nextInt((viewModelProvider
                                              .musicListProvider.length -
                                          1) -
                                      0);
                                  viewModelProvider.globalIndex = randomIndex;
                                  viewModelProvider.setGlobalIndex(
                                      viewModelProvider.globalIndex);
                                  print(randomIndex);
                                  setState(
                                    () {},
                                  );
                                } else if (viewModelProvider.isRandom == true) {
                                  viewModelProvider.isRandom = false;
                                  viewModelProvider
                                      .setIsRandom(viewModelProvider.isRandom);
                                }
                              },
                              icon: Icon(Icons.shuffle,
                                  size: 28,
                                  color: viewModelProvider.isRandom == false
                                      ? Colors.white
                                      : Colors.blueGrey)),
                          IconButton(
                              onPressed: () {
                                if (viewModelProvider.globalIndex > 0) {
                                  viewModelProvider.globalIndex--;
                                  viewModelProvider.setGlobalIndex(
                                      viewModelProvider.globalIndex);
                                  viewModelProvider.selectedMusicProvider =
                                      viewModelProvider.musicListProvider[
                                          viewModelProvider.globalIndex];
                                  viewModelProvider.setSelectedMusic(
                                      viewModelProvider.selectedMusicProvider);
                                  playMusic();
                                }
                              },
                              icon: Icon(
                                Icons.skip_previous,
                                size: 34,
                                color: Colors.white,
                              )),
                          GestureDetector(
                            onTap: () {
                              audioPlayerState == PlayerState.PLAYING
                                  ? pauseMusic()
                                  : playMusic();
                              setState(() {});
                            },
                            child: Icon(
                              audioPlayerState == PlayerState.PLAYING
                                  ? Icons.pause_circle_filled_outlined
                                  : Icons.play_circle_fill_outlined,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if (viewModelProvider.globalIndex ==
                                    viewModelProvider.musicListProvider.length -
                                        1) {
                                  viewModelProvider.globalIndex = 0;
                
                                  viewModelProvider.setGlobalIndex(
                                      viewModelProvider.globalIndex);
                                  viewModelProvider.selectedMusicProvider =
                                      viewModelProvider.musicListProvider[
                                          viewModelProvider.globalIndex];
                                  viewModelProvider.setSelectedMusic(
                                      viewModelProvider.selectedMusicProvider);
                                  playMusic();
                                } else {
                                  viewModelProvider.globalIndex++;
                                  viewModelProvider.setGlobalIndex(
                                      viewModelProvider.globalIndex);
                                  viewModelProvider.selectedMusicProvider =
                                      viewModelProvider.musicListProvider[
                                          viewModelProvider.globalIndex];
                                  viewModelProvider.setSelectedMusic(
                                      viewModelProvider.selectedMusicProvider);
                                  playMusic();
                                }
                              },
                              icon: Icon(
                                Icons.skip_next,
                                size: 34,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {
                                if (viewModelProvider.isLoop == false) {
                                  audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                                  viewModelProvider.isLoop = true;
                                  viewModelProvider
                                      .setIsLoop(viewModelProvider.isLoop);
                                  setState(() {});
                                } else if (viewModelProvider.isLoop == true) {
                                  audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
                                  viewModelProvider.isLoop = false;
                                  viewModelProvider
                                      .setIsLoop(viewModelProvider.isLoop);
                                  setState(() {});
                                }
                              },
                              icon: Icon(
                                Icons.repeat,
                                size: 28,
                                color: viewModelProvider.isLoop == false
                                    ? Colors.white
                                    : Colors.blueGrey,
                              )),
                        ],
                      )
                    ],
                  ),
                )),
              ),
            );
          }),
        );
      },
    );
  }
}

