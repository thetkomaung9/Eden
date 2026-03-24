import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/impact_model.dart';
import '../models/cam_model.dart';

class GameProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<KarmaPost> _currentPosts = [];

  // ဥပမာအနေနဲ့ Public Cam စာရင်း (တကယ်တော့ Firestore ကနေယူရမှာပါ)
  final List<PublicCam> _publicCams = [
    PublicCam(
        id: "cam1",
        title: "New York Times Square",
        videoUrl:
            "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
        lat: 40.7580,
        lng: -73.9855),
    PublicCam(
        id: "cam2",
        title: "Tokyo Shibuya",
        videoUrl:
            "https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8",
        lat: 35.6617,
        lng: 139.7040),
  ];

  Stream<List<KarmaPost>> streamKarmaPosts() {
    return _db
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) {
      _currentPosts =
          snap.docs.map((doc) => KarmaPost.fromFirestore(doc)).toList();
      notifyListeners();
      return _currentPosts;
    });
  }

  // Markers ပေါင်းစပ်ထုတ်ပေးခြင်း (Karma Posts + Public Cams)
  Set<Marker> getCombinedMarkers(
      BuildContext context, Function(PublicCam) onCamTap) {
    Set<Marker> markers = {};

    // 1. User Posts (Green Markers)
    for (var post in _currentPosts) {
      markers.add(Marker(
        markerId: MarkerId(post.id),
        position: LatLng(post.location.latitude, post.location.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    // 2. Public Cams (Blue/Video Markers)
    for (var cam in _publicCams) {
      markers.add(Marker(
        markerId: MarkerId(cam.id),
        position: LatLng(cam.lat, cam.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        onTap: () => onCamTap(cam),
      ));
    }

    return markers;
  }

  Stream<List<CountryScore>> streamCountryRankings() {
    return _db
        .collection('countries')
        .orderBy('greenScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => CountryScore.fromFirestore(doc.data()))
            .toList());
  }
}
