//import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:golpo/provider/view_model_provider.dart';
import 'package:golpo/screens/home_screen.dart';
import 'package:golpo/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class PlayerDetails extends StatefulWidget {
  const PlayerDetails({Key? key}) : super(key: key);

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  late ViewModelProvider viewModelProvider;
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.PLAYING;
  Duration position = new Duration();
  Duration musicLength = new Duration();
  int timeProgress = 0;
  int audioDuration = 0;
  @override
  void initState() {
    super.initState();
    viewModelProvider = Provider.of<ViewModelProvider>(context, listen: false);

    audioPlayer.onPlayerStateChanged.listen((state) {
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
        viewModelProvider.selectedMusicProvider =
            viewModelProvider.musicListProvider[viewModelProvider.globalIndex];
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
        viewModelProvider.selectedMusicProvider =
            viewModelProvider.musicListProvider[viewModelProvider.globalIndex];
        viewModelProvider
            .setSelectedMusic(viewModelProvider.selectedMusicProvider);
        playMusic();
      }
    });

    /// Optional
    audioPlayer.setUrl(viewModelProvider.selectedMusicProvider != null
        ? "none"
        : viewModelProvider.selectedMusicProvider!
            .url); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
  }

  // / Compulsory
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
    return Consumer<ViewModelProvider>(
      builder: (context, viewModelProvider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading: IconButton(
                onPressed: () {},
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
                        CustomText(
                          text: viewModelProvider.selectedMusicProvider!.title,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: viewModelProvider.selectedMusicProvider?.lebel,
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
                // Slider(
                //   value: 0.5,
                //   onChanged: (v) {},
                //   min: 0,
                //   max: 1,
                //   inactiveColor: Colors.grey,
                //   activeColor: Colors.white,
                // ),
                Slider.adaptive(
                  value: timeProgress.toDouble(),
                  max: audioDuration.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      timeProgress = value.toInt();
                    });
                    // setState(
                    //     () => timeProgress = value.toInt());
                    // setState((() => timeProgress));
                    seekToSec(timeProgress);
                    setState(() {});
                    // value:
                    // timeProgress;
                    // setState;
                  },
                  inactiveColor: Colors.grey,
                  activeColor: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.shuffle,
                          size: 28,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          if (viewModelProvider.globalIndex > 0) {
                            viewModelProvider.globalIndex--;
                            viewModelProvider
                                .setGlobalIndex(viewModelProvider.globalIndex);
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
                              viewModelProvider.musicListProvider.length - 1) {
                            viewModelProvider.globalIndex = 0;

                            viewModelProvider
                                .setGlobalIndex(viewModelProvider.globalIndex);
                            viewModelProvider.selectedMusicProvider =
                                viewModelProvider.musicListProvider[
                                    viewModelProvider.globalIndex];
                            viewModelProvider.setSelectedMusic(
                                viewModelProvider.selectedMusicProvider);
                            playMusic();
                          } else {
                            viewModelProvider.globalIndex++;
                            viewModelProvider
                                .setGlobalIndex(viewModelProvider.globalIndex);
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
                          Icons.loop_outlined,
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
        );
      },
    );
  }
}
