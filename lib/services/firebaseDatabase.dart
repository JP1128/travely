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
  print(event.toMap());
  await eventRef.set(event.toMap());
}

void deleteEvent(String eventKey) async {
  await eventsDatabase.child(eventKey).remove();
}

Stream<List<EventModel>?> streamEvents(String tripKey) {
  var events = eventsDatabase.orderByChild("tripKey").equalTo(tripKey);

  var stream = events.onValue;
  return stream.map((event) {
    var snapshot = event.snapshot;

    if (snapshot.exists && snapshot.children.isNotEmpty) {
      return snapshot.children.map((data) => EventModel.fromMap(data.key!, data.value!)).toList();
    }

    return List.empty();
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
