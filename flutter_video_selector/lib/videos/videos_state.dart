part of 'videos_bloc.dart';

@immutable
abstract class VideosState {}

class InitialVideosState extends VideosState {}

class ListVideosState extends VideosState {
  final List<File> videos;

  ListVideosState(this.videos);
}