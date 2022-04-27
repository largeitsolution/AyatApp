import 'package:flutter/material.dart';
import 'package:golpo/model/music_model.dart';

class ViewModelProvider extends ChangeNotifier {
  List<MusicModel> _list = [
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

  List<MusicModel> get musicListProvider => _list;
  MusicModel? selectedMusicProvider;

  int globalIndex = 0;
  bool isLoop = false;
  bool isRandom = false;
  int prog = 0;
  int totalDuration = 0;

  setGlobalIndex(index) {
    globalIndex = index;
    notifyListeners();
  }

  setSelectedMusic(music) {
    selectedMusicProvider = music;
    notifyListeners();
  }

  setIsLoop(loop) {
    isLoop = loop;
    notifyListeners();
  }

  setIsRandom(ran) {
    isRandom = ran;
    notifyListeners();
  }

  setProg(p) {
    prog = p;
    notifyListeners();
  }

  setTotalDuration(td) {
    totalDuration = td;
    notifyListeners();
  }
}
