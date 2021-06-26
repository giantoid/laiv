import 'dart:math';

import 'package:laiv/controllers/auth_controller.dart';
import 'package:laiv/controllers/streaming_controller.dart';
import 'package:laiv/models/streaming.dart';
import 'package:laiv/screens/pages/streaming_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AddLiveStream extends StatefulWidget {
  @override
  _AddLiveStreamState createState() => _AddLiveStreamState();
}

class _AddLiveStreamState extends State<AddLiveStream> {
  Streaming streaming;

  AuthController _authController = AuthController();
  StreamingController _streamingController = StreamingController();

  final _titleController = TextEditingController();
  bool _validateError = false;
  bool isPublic;

  String _currentUserId;

  String _chanelId;

  @override
  void initState() {
    super.initState();

    setState(() {
      _chanelId = Random().nextInt(1000).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    errorText: _validateError ? 'Judul wajib diisi' : null,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Judul',
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    title: const Text('Public'),
                    leading: Radio(
                      value: true,
                      groupValue: isPublic,
                      onChanged: (value) {
                        setState(() {
                          isPublic = value;
                        });
                        print(isPublic);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Private'),
                    leading: Radio(
                      value: false,
                      groupValue: isPublic,
                      onChanged: (value) {
                        setState(() {
                          isPublic = value;
                        });
                        print(isPublic);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _titleController.text.isEmpty
                                ? _validateError = true
                                : _validateError = false;
                          });
                          _authController.getCurrentUser().then((user) {
                            _currentUserId = user.uid;

                            setState(() {
                              streaming = Streaming(
                                title: _titleController.text,
                                streamerId: user.uid,
                                streamerName: user.displayName,
                                streamerPic: user.photoURL,
                                chanelId: _chanelId,
                                isPublic: isPublic,
                              );
                            });
                          });
                          await _handleCameraAndMic();
                          bool makeStreaming = await _streamingController
                              .makeStreaming(streaming: streaming);

                          if (makeStreaming) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StreamingPage(
                                  streaming: streaming,
                                ),
                              ),
                            ).then((_) {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitDown,
                                DeviceOrientation.portraitUp,
                              ]);
                              setState(() {
                                _chanelId = Random().nextInt(1000).toString();
                              });
                            });
                          }
                        },
                        child: Text('Mulai Live Streaming'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await [Permission.camera, Permission.microphone].request();
  }
}
