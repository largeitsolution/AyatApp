// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:golpo/provider/view_model_provider.dart';
// import 'package:golpo/screens/home_screen.dart';
// import 'package:golpo/screens/player_details.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:provider/provider.dart';

// Future <void> main() async {
//   await  AudioService.init<AudioHandler>(builder:()=>
//  MyAudioHandler(),
//     config: AudioServiceConfig(
//       androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
//       androidNotificationChannelName: 'Music playback',
//   ,)  .init(androidNotificationChannelId:'com.example.golpo',
//   androidNotificationChannelName: 'golpo'
//   ,androidNotificationOngoing: true );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<ViewModelProvider>.value(
//           value: ViewModelProvider(),
//         )
//       ],
//       child: MaterialApp(debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or simply save your changes to "hot reload" in a Flutter IDE).
//           // Notice that the counter didn't reset back to zero; the application
//           // is not restarted.
//           primarySwatch: Colors.blue,
//         ),
//         home: HomeScreen(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
// ignore_for_file: public_member_api_docs

// FOR MORE EXAMPLES, VISIT THE GITHUB REPOSITORY AT:
//
//  https://github.com/ryanheise/audio_service
//
// This example implements a minimal audio handler that renders the current
// media item and playback state to the system notification and responds to 4
// media actions:
//
// - play
// - pause
// - seek
// - stop
//
// To run this example, use:
//
// flutter run

import 'dart:async';

import 'package:audio_service/audio_service.dart';
// import 'package:audio_service_example/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:golpo/model/music_model.dart';
import 'package:golpo/provider/view_model_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

// You might want to provide this using dependency injection rather than a
// global variable.
late AudioHandler _audioHandler;

Future<void> main() async {
  _audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Service Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Service Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Show media item title
            StreamBuilder<MediaItem?>(
              stream: _audioHandler.mediaItem,
              builder: (context, snapshot) {
                final mediaItem = snapshot.data;
                return Text(mediaItem?.title ?? '');
              },
            ),
            // Play/pause/stop buttons.
            StreamBuilder<bool>(
              stream: _audioHandler.playbackState
                  .map((state) => state.playing)
                  .distinct(),
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(Icons.fast_rewind, _audioHandler.rewind),
                    if (playing)
                      _button(Icons.pause, _audioHandler.pause)
                    else
                      _button(Icons.play_arrow, _audioHandler.play),
                    _button(Icons.stop, _audioHandler.stop),
                    _button(Icons.fast_forward, _audioHandler.fastForward),
                  ],
                );
              },
            ),
            // A seek bar.
            // StreamBuilder<MediaState>(
            //   stream: _mediaStateStream,
            //   builder: (context, snapshot) {
            //     final mediaState = snapshot.data;
            //     return SeekBar(
            //       duration: mediaState?.mediaItem?.duration ?? Duration.zero,
            //       position: mediaState?.position ?? Duration.zero,
            //       onChangeEnd: (newPosition) {
            //         _audioHandler.seek(newPosition);
            //       },
            //     );
            //   },
            // ),
            // Display the processing state.
            StreamBuilder<AudioProcessingState>(
              stream: _audioHandler.playbackState
                  .map((state) => state.processingState)
                  .distinct(),
              builder: (context, snapshot) {
                final processingState =
                    snapshot.data ?? AudioProcessingState.idle;
                return Text(
                    "Processing state: ${describeEnum(processingState)}");
              },
            ),
          ],
        ),
      ),
    );
  }

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          _audioHandler.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem, position));

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

/// An [AudioHandler] for playing a single item.
var current =0;
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {



  static final _item = MediaItem(
    
    id: musicList[current].url,
    // 'https://it-dk.com/media-demo/demo-1.mp3',
    album: "Bororsa",
    title: "Allah",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );

  final _player = AudioPlayer();


  /// Initialise our audio handler.
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
     mediaItem.add(_item);


    // Load the player.
    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
  // for(int i=0;i<musicList.length;i++){

  //   _player.setAudioSource(AudioSource.uri(Uri.parse(
  //     musicList[i].url)));
  // }
   
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
      
    );
  }
}
// import 'package:audio_service/audio_service.dart';

// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(

//         primarySwatch: Colors.blue,
//       ),
//       home: AudioServiceWidget(child:HomePage()),
//     );
//   }
// }


// MediaItem mediaItem = MediaItem(
//     id: songList[0].url,
//     title: songList[0].name,
//     artUri: Uri.parse(songList[0].icon),
//     album: songList[0].album,
//     duration: songList[0].duration,
//     artist: songList[0].artist);

// int current = 0;

// _backgroundTaskEntrypoint() {
//   AudioServiceBackground.run(() => AudioPlayerTask());
// }

// class AudioPlayerTask extends BackgroundAudioTask {
//   final _audioPlayer = AudioPlayer();

//   @override
//   Future<void> onStart(Map<String, dynamic> params) async {
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       // MediaAction.seekTo
//     ], playing: true,
//     //  processingState: AudioProcessingState.connecting
//      );
//     // Connect to the URL
//     await _audioPlayer.setUrl(mediaItem.id);
//     AudioServiceBackground.setMediaItem(mediaItem);
//     // Now we're ready to play
//     _audioPlayer.play();
//     // Broadcast that we're playing, and what controls are available.
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       // MediaAction.seekTo
//     ], playing: true, processingState: AudioProcessingState.ready);
//   }

//   @override
//   Future<void> onStop() async {
//     AudioServiceBackground.setState(
//         controls: [],
//         playing: false,
//         processingState: AudioProcessingState.ready);
//     await _audioPlayer.stop();
//     await super.onStop();
//   }

//   @override
//   Future<void> onPlay() async {
//     AudioServiceBackground.setState(controls: [
//       MediaControl.pause,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       // MediaAction.seekTo
//     ], playing: true, processingState: AudioProcessingState.ready);
//     await _audioPlayer.play();
//     return super.onPlay();
//   }

//   @override
//   Future<void> onPause() async {
//     AudioServiceBackground.setState(controls: [
//       MediaControl.play,
//       MediaControl.stop,
//       MediaControl.skipToNext,
//       MediaControl.skipToPrevious
//     ], systemActions: [
//       // MediaAction.seekTo
//     ], playing: false, processingState: AudioProcessingState.ready);
//     await _audioPlayer.pause();
//     return super.onPause();
//   }

//   @override
//   Future<void> onSkipToNext() async {
//     if (current < songList.length - 1)
//       current = current + 1;
//     else
//       current = 0;
//     mediaItem = MediaItem(
//         id: songList[current].url,
//         title: songList[current].name,
//         artUri: Uri.parse(songList[current].icon),
//         album: songList[current].album,
//         duration: songList[current].duration,
//         artist: songList[current].artist);
//     AudioServiceBackground.setMediaItem(mediaItem);
//     await _audioPlayer.setUrl(mediaItem.id);
//     AudioServiceBackground.setState(position: Duration.zero);
//     return super.onSkipToNext();
//   }

//   @override
//   Future<void> onSkipToPrevious() async {
//     if (current != 0)
//       current = current - 1;
//     else
//       current = songList.length - 1;
//     mediaItem = MediaItem(
//         id: songList[current].url,
//         title: songList[current].name,
//         artUri: Uri.parse(songList[current].icon),
//         album: songList[current].album,
//         duration: songList[current].duration,
//         artist: songList[current].artist);
//     AudioServiceBackground.setMediaItem(mediaItem);
//     await _audioPlayer.setUrl(mediaItem.id);
//     AudioServiceBackground.setState(position: Duration.zero);
//     return super.onSkipToPrevious();
//   }

//   @override
//   Future<void> onSeekTo(Duration position) {
//     _audioPlayer.seek(position);
//     AudioServiceBackground.setState(position: position);
//     return super.onSeekTo(position);
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             appBar: AppBar(
//               title: Text("Background Music"),
//               actions: [
//                 IconButton(
//                     icon: Icon(Icons.stop),
//                     onPressed: () {
//                       AudioService.stop();
//                     })
//               ],
//             ),
//             body: Center(
//               child: Column(
//                 children: [
//                   StreamBuilder<MediaItem>(
//                       // ignore: deprecated_member_use
//                       stream: AudioService.currentMediaItemStream,
//                       builder: (_, snapshot) {
//                         return Text(snapshot.data?.title ?? "title");
//                       }),
//                   StreamBuilder<PlaybackState>(
//                       stream: AudioService.playbackStateStream,
//                       builder: (context, snapshot) {
//                         final playing = snapshot.data?.playing ?? false;
//                         if (playing)
//                           return ElevatedButton(
//                               child: Text("Pause"),
//                               onPressed: () {
//                                 AudioService.pause();
//                               });
//                         else
//                           return ElevatedButton(
//                               child: Text("Play"),
//                               onPressed: () {
//                                 if (AudioService.running) {
//                                   AudioService.play();
//                                 } else {
//                                   AudioService.start(
//                                     backgroundTaskEntrypoint:
//                                         _backgroundTaskEntrypoint,
//                                   );
//                                 }
//                               });
//                       }),
//                   ElevatedButton(
//                       onPressed: () async {
//                         await AudioService.skipToNext();
//                       },
//                       child: Text("Next Song")),
//                   ElevatedButton(
//                       onPressed: () async {
//                         await AudioService.skipToPrevious();
//                       },
//                       child: Text("Previous Song")),
//                   StreamBuilder<Duration>(
//                     stream: AudioService.positionStream,
//                     builder: (_, snapshot) {
//                       final mediaState = snapshot.data;
//                       return Slider(
//                         value: mediaState?.inSeconds?.toDouble() ?? 0,
//                         min: 0,
//                         max: mediaItem.duration.inSeconds.toDouble(),
//                         onChanged: (val) {
//                           AudioService.seekTo(Duration(seconds: val.toInt()));
//                         },
//                       );
//                     },
//                   )
//                 ],
//               ),
//             )));
//   }
// }
class Song {
  final String url;
  final String name;
  final String artist;
  final String icon;
  final String album;
  final Duration? duration;
  Song(
      {this.url='', this.name='', this.artist='', this.icon='',this.duration, this.album='',  });
}
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
List<Song> songList = [
  Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
      name: "Song 1",
      artist: "Artist 1",
      duration: Duration(minutes: 6, seconds: 12),
      icon:
          "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/artistic-album-cover-design-template-d12ef0296af80b58363dc0deef077ecc_screen.jpg",
      album: "Album 1"),
  Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
      name: "Song 2",
      artist: "Artist 2",
      duration: Duration(minutes: 7, seconds: 5),
      icon:
          "https://i.pinimg.com/originals/1f/c6/69/1fc66962352f4f2cdef41af009215cc4.jpg",
      album: "Album 2"),
  Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
      name: "Song 3",
      duration: Duration(minutes: 5, seconds: 44),
      artist: "Artist 3",
      icon:
          "https://i.pinimg.com/736x/ea/1f/64/ea1f64668a0af149a3277db9e9e54824.jpg",
      album: "Album 3"),
  Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
      name: "Song 4",
      artist: "Artist 4",
      duration: Duration(minutes: 5, seconds: 2),
      icon:
          "https://magazine.artland.com/wp-content/uploads/2020/02/Webp.net-compress-image-67-1.jpg",
      album: "Album 4")
];

