part of 'videos_bloc.dart';

@immutable
abstract class VideosEvent {}

class AddVideoEvent extends VideosEvent {
  final File videoFile;

  AddVideoEvent(this.videoFile);
}

class PlayVideoEvent extends VideosEvent {
  PlayVideoEvent();
}