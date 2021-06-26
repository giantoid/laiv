import 'dart:math';

import 'package:laiv/controllers/streaming_controller.dart';
import 'package:laiv/models/streaming.dart';
import 'package:laiv/models/users.dart';
import 'package:laiv/screens/pages/streaming_page.dart';
import 'package:flutter/material.dart';

class StreamingUtilities {
  static final StreamingController streamingController = StreamingController();

  static dial({Users from, Users to, context}) async {
    Streaming streaming = Streaming(
      streamerId: from.uid,
      streamerName: from.name,
      streamerPic: from.profilePhoto,
      viewerId: to.uid,
      viewerName: to.name,
      viewerPic: to.profilePhoto,
      chanelId: Random().nextInt(1000).toString(),
    );

    bool streamingMade =
        await streamingController.makeStreaming(streaming: streaming);

    if (streamingMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamingPage(streaming: streaming),
        ),
      );
    }
  }
}
