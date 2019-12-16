import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_selector/videos/videos_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideosBloc _bloc = VideosBloc();
  VideoPlayerController _controller;

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }

    super.dispose();
  }

  Future _pickVideo() async {
    var videoFile = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _bloc.add(AddVideoEvent(videoFile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildPage(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        tooltip: 'Select video',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildEmptyPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Use floating action button to select videos',
          )
        ],
      ),
    );
  }

  Widget _buildListPage(List<File> files) {
    return Center(
        child: ListView.builder(
      itemCount: files.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            child: ListTile(
          title: Text((files[index].path)),
          onTap: () {
            _controller = VideoPlayerController.file(files[index]);
            _controller
              ..initialize().then((_) {
                _bloc.add(PlayVideoEvent());
                _controller.play();
              });
          },
        ));
      },
    ));
  }

  Widget _buildPage(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, VideosState state) {
        if (!(state is PlayVideoState) && _controller != null) {
          _controller.pause();
          _controller.dispose();
          _controller = null;
        }

        if (state is InitialVideosState) {
          return _buildEmptyPage();
        } else if (state is ListVideosState) {
          return _buildListPage(state.videos);
        } else if (state is PlayVideoState) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        }
        return _buildEmptyPage();
      },
    );
  }
}
