import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_selector/video_screen.dart';
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
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
            'Use floating action button to select video',
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoScreen(video: files[index])),
            );
          },
        ));
      },
    ));
  }

  Widget _buildPage(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, VideosState state) {
        if (state is InitialVideosState) {
          return _buildEmptyPage();
        } else if (state is ListVideosState) {
          return _buildListPage(state.videos);
        }
        return _buildEmptyPage();
      },
    );
  }
}
