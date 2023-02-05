import 'package:travely/models/databaseModel.dart';
import 'package:travely/models/time.dart';

class EventModel extends DatabaseModel {
  String? key;

  String? tripKey;
  String? eventName;

  Time? startTime;
  Time? endTime;

  String? description;

  String? placeId;

  EventModel({
    this.key,
    this.tripKey,
    this.eventName,
    this.startTime,
    this.endTime,
    this.description,
    this.placeId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "tripKey": tripKey,
      "eventName": eventName,
      "startTime": startTime?.toMinutes().minutes,
      "endTime": endTime?.toMinutes().minutes,
      "description": description,
      "placeId": placeId,
    };
  }

  static EventModel fromMap(String key, dynamic map) {
    Time? startTime = map.containsKey("startTime") ? Minutes(map['startTime']).toTime() : null;
    Time? endTime = map.containsKey("endTime") ? Minutes(map['endTime']).toTime() : null;

    return EventModel(
      key: key,
      tripKey: map['tripKey'],
      eventName: map['eventName'],
      startTime: startTime,
      endTime: endTime,
      description: map['description'],
      placeId: map['placeId'],
    );
  }
}
