import 'package:cloud_firestore/cloud_firestore.dart';

class Streaming {
  String title;
  String description;
  String streamerId;
  String streamerName;
  String streamerPic;
  String viewerId;
  String viewerName;
  String viewerPic;
  String chanelId;
  bool isPublic;
  Timestamp startedAt;
  Timestamp endedAt;

  Streaming({
    this.title,
    this.streamerId,
    this.streamerName,
    this.streamerPic,
    this.viewerId,
    this.viewerName,
    this.viewerPic,
    this.chanelId,
    this.isPublic,
    this.startedAt,
    this.endedAt,
  });

  Map<String, dynamic> toMap(Streaming streaming) {
    Map<String, dynamic> map = Map();
    map['title'] = streaming.title;
    map['streamer_id'] = streaming.streamerId;
    map['streamer_name'] = streaming.streamerName;
    map['streamer_pic'] = streaming.streamerPic;
    map['viewer_id'] = streaming.viewerId;
    map['viewer_name'] = streaming.viewerName;
    map['viewer_pic'] = streaming.viewerPic;
    map['chanel_id'] = streaming.chanelId;
    map['is_public'] = streaming.isPublic;
    map['started_at'] = streaming.startedAt;
    map['ended_at'] = streaming.endedAt;
    return map;
  }

  Streaming.fromMap(Map map) {
    this.title = map["title"];
    this.streamerId = map["streamer_id"];
    this.streamerName = map["streamer_name"];
    this.streamerPic = map["streamer_pic"];
    this.viewerId = map["viewer_id"];
    this.viewerName = map["viewer_name"];
    this.viewerPic = map["streamer_pic"];
    this.chanelId = map["chanel_id"];
    this.isPublic = map["is_public"];
    this.startedAt = map["start_ed"];
    this.endedAt = map["ended_at"];
  }
}
