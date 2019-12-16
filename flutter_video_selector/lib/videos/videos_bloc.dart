import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'videos_event.dart';

part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  @override
  VideosState get initialState => InitialVideosState();
  List<File> videos = [];

  @override
  Stream<VideosState> mapEventToState(VideosEvent event) async* {
    if (event is AddVideoEvent) {
      videos.add(event.videoFile);
      yield ListVideosState(videos);
    }
  }
}
