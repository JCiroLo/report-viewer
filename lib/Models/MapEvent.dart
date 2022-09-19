class MapEvent {
  final int type;
  final int zoneCode;
  final int status;
  final double latitude;
  final double longitude;
  final String date;
  final String time;
  final String userId;
  final String description;
  final String comment;

  const MapEvent(
      {required this.description,
      required this.comment,
      required this.latitude,
      required this.longitude,
      required this.date,
      required this.status,
      required this.time,
      required this.type,
      required this.userId,
      required this.zoneCode});
}
