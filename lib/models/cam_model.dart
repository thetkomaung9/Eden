class PublicCam {
  final String id;
  final String title;
  final String videoUrl; // HLS (.m3u8) သို့မဟုတ် MP4 link
  final double lat;
  final double lng;

  PublicCam(
      {required this.id,
      required this.title,
      required this.videoUrl,
      required this.lat,
      required this.lng});
}
