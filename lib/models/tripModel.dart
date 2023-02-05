import 'package:travely/models/databaseModel.dart';

class TripModel extends DatabaseModel {
  String? key; // primary id
  String? tripName;
  int? days;

  TripModel({
    this.key,
    this.tripName,
    this.days,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "tripName": tripName,
      "days": days,
    };
  }

  static TripModel fromMap(String key, dynamic map) {
    return TripModel(
      key: key,
      tripName: map['tripName'],
      days: map['days'],
    );
  }
}
