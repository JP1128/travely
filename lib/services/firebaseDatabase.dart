import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps/google_maps.dart';
import 'package:travely/models/eventModel.dart';
import 'package:travely/models/time.dart';
import 'package:travely/models/tripModel.dart';
import 'package:uuid/uuid.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference eventsDatabase = database.ref('events');
DatabaseReference tripsDatabase = database.ref('trips');
DatabaseReference usersDatabase = database.ref('users');

void updateEvent(EventModel event) async {
  event.key ??= const Uuid().v4();

  var eventRef = eventsDatabase.child(event.key!);
  await eventRef.set(event.toMap());
}

Stream<List<EventModel>?> streamEvents(String tripKey, int day) {
  var events = eventsDatabase
      .equalTo(tripKey, key: 'tripKey') //
      .endAt(Minutes.fromDay(day), key: 'endTime')
      .startAt(Minutes.fromDay(day), key: 'startTime');

  var stream = events.onValue;
  return stream.map((event) {
    var snapshot = event.snapshot;

    if (snapshot.exists) {
      return snapshot.children.map((data) => EventModel.fromMap(data.key!, data.value!)).toList();
    }

    return null;
  });
}

void updateTrip(TripModel trip) async {
  trip.key ??= const Uuid().v4();

  var tripRef = tripsDatabase.child(trip.key!);
  await tripRef.set(trip.toMap());
}

Stream<List<TripModel>?> streamTrips({String? userKey}) {
  var trips = usersDatabase;
  if (userKey != null) trips = trips.equalTo(userKey, key: 'userKey').ref;

  var stream = trips.onValue;
  return stream.map((event) {
    var snapshot = event.snapshot;

    if (snapshot.exists) {
      return snapshot.children.map((data) => TripModel.fromMap(data.key!, data.value!)).toList();
    }

    return null;
  });
}
