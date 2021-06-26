import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laiv/constants/string.dart';
import 'package:laiv/models/streaming.dart';

class StreamingController {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _streamingCollection =
      FirebaseFirestore.instance.collection(STREAMING_COLLECTION);

  Stream<DocumentSnapshot> streamingStream({String uid}) =>
      _streamingCollection.doc(uid).snapshots();

  Future<bool> makeStreaming({Streaming streaming}) async {
    try {
      streaming.startedAt = Timestamp.now();
      Map<String, dynamic> onGoingMap = streaming.toMap(streaming);

      await _streamingCollection.doc(streaming.streamerId).set(onGoingMap);
      await firestore
          .collection(USERS_COLLECTION)
          .doc(streaming.streamerId)
          .update({"is_live": true});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endStreaming(String streamerId) async {
    try {
      Stream<DocumentSnapshot> stream =
          _streamingCollection.doc(streamerId).snapshots();
      List<Streaming> list = List<Streaming>();
      stream.forEach((data) {
        list.add(Streaming.fromMap(data.data()));

        Streaming streaming = Streaming(
          title: data['title'],
          streamerId: data["streamer_id"],
          streamerName: data["streamer_name"],
          streamerPic: data["streamer_pic"],
          viewerId: data["viewer_id"],
          chanelId: data["chanel_id"],
          isPublic: data["is_public"],
          startedAt: data["started_at"],
          endedAt: data["ended_at"],
        );

        Map<String, dynamic> historyMap = streaming.toMap(streaming);
        _streamingCollection
            .doc(streamerId)
            .collection("history")
            .add(historyMap);
      });

      await firestore
          .collection(USERS_COLLECTION)
          .doc(streamerId)
          .update({"is_live": false});

      await _streamingCollection.doc(streamerId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
