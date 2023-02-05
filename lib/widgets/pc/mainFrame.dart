import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/constant.dart';
import 'package:travely/models/eventModel.dart';
import 'package:travely/models/time.dart';
import 'package:travely/models/wrapper.dart';
import 'package:travely/services/firebaseDatabase.dart';
import 'package:travely/style.dart';
import 'package:travely/widgets/pc/text_editor.dart';
import 'package:google_directions_api/google_directions_api.dart' as gd;

gm.CameraPosition _defaultPosition = const gm.CameraPosition(
  target: gm.LatLng(33.94817883140854, -83.3772738224502),
  zoom: 14.4746,
);

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key, required this.tripKey}) : super(key: key);

  final String tripKey;

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  final Completer<gm.GoogleMapController> _gmController = Completer();
  final Wrapper<String?> _placeId = Wrapper();

  final TextEditingController _eventTitle = TextEditingController();
  final TextEditingController _eventAddress = TextEditingController();
  final TextEditingController _eventDescription = TextEditingController();

  EventModel? currentEvent;

  late String _mapStyle;

  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  int currentDay = 1;

  void resetCurrentEvent() {
    _eventTitle.text = currentEvent!.eventName ?? "New event";
    _eventAddress.text = currentEvent!.address ?? "address";
    _eventDescription.text = currentEvent!.description ?? "";
    start = (currentEvent!.startTime != null)
        ? //
        TimeOfDay(hour: currentEvent!.startTime!.hour, minute: currentEvent!.startTime!.minutes)
        : TimeOfDay.now();
    end = (currentEvent!.endTime != null)
        ? //
        TimeOfDay(hour: currentEvent!.endTime!.hour, minute: currentEvent!.endTime!.minutes)
        : TimeOfDay(hour: start.hour, minute: start.minute);
    _placeId.value = null;
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('mapStyle.json').then((string) {
      _mapStyle = string;
    });

    if (_eventTitle.text.isEmpty) _eventTitle.text = "Event title";
    if (_eventAddress.text.isEmpty) _eventAddress.text = "Address";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventModel>?>(
        initialData: [],
        stream: streamEvents(widget.tripKey),
        builder: (context, snapshot) {
          var eventLists = snapshot.data!;

          if (eventLists.isNotEmpty) {
            eventLists.removeWhere((event) {
              return event.startTime!.toMinutes().minutes > Minutes.fromDay(currentDay) && //
                  event.endTime!.toMinutes().minutes < Minutes.fromDay(currentDay - 1);
            });

            eventLists.sort((a, b) {
              return a.startTime!.toMinutes().minutes - b.startTime!.toMinutes().minutes;
            });
          }

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: boxDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15.w,
                  child: Builder(
                    builder: (context) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DayChangeWidget(
                              currentDay: currentDay,
                              maxDay: 5,
                              leftOnPressed: () {},
                              rightOnPressed: () {},
                              createOnPressed: () {},
                            ),
                            const SizedBox(height: 10),
                            DayConfigurationRow(),
                            const SizedBox(height: 20),
                            // Text(
                            //   "Traffic data for March, 16",
                            //   textAlign: TextAlign.center,
                            //   style: Theme.of(context).textTheme.bodyLarge,
                            // ),
                            // const SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  currentEvent = EventModel(
                                    tripKey: widget.tripKey,
                                  );
                                  resetCurrentEvent();
                                });
                              },
                              style: eventWidgetButtonStyle,
                              child: Icon(Icons.add),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Builder(builder: (context) {
                                return ListView.separated(
                                  itemBuilder: ((context, index) {
                                    var event = eventLists[index];
                                    return OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          currentEvent = event;
                                          resetCurrentEvent();
                                        });
                                      },
                                      style: eventWidgetButtonStyle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  event.eventName!,
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      event.startTime!.toTimeString(),
                                                      style: Theme.of(context).textTheme.titleSmall,
                                                    ),
                                                    Text(
                                                      " - ",
                                                      style: Theme.of(context).textTheme.titleSmall,
                                                    ),
                                                    Text(
                                                      event.endTime!.toTimeString(),
                                                      style: Theme.of(context).textTheme.titleSmall,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  separatorBuilder: ((context, index) {
                                    // return Placeholder();

                                    var prev = eventLists[index];
                                    var next = eventLists[index + 1];

                                    final directionService = gd.DirectionsService();
                                    final request = gd.DirectionsRequest(
                                      origin: "place_id:" + prev.placeId!,
                                      destination: "place_id:" + next.placeId!,
                                      travelMode: gd.TravelMode.driving,
                                    );

                                    Completer<gd.DirectionsResult> resultCompleter = Completer();
                                    Completer<gd.DirectionsStatus> statusCompleter = Completer();
                                    directionService.route(request, (result, status) {
                                      resultCompleter.complete(result);
                                      statusCompleter.complete(status);
                                    });

                                    return FutureBuilder(
                                        future: resultCompleter.future,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var result = snapshot.data;

                                            print(result!.routes!.first);

                                            var routes = result!.routes;
                                            var bestRoute = routes!.first;
                                            var bestLeg = bestRoute.legs!.first;

                                            var distance = bestLeg.distance!.value!.toDouble() / 1609;

                                            print(distance);

                                            return Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              child: TrafficItem(
                                                distance: distance,
                                                duration: Minutes(bestLeg.duration!.value!.toInt() ~/ 60),
                                                summary: bestRoute.summary!,
                                              ),
                                            );
                                          }

                                          return Center(child: CircularProgressIndicator());
                                        });
                                  }),
                                  itemCount: eventLists.length,
                                );
                              }),
                            ),
                          ],
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: boxDecoration,
                        clipBehavior: Clip.hardEdge,
                        child: FutureBuilder(
                          future: Future<gm.CameraPosition>(() {
                            if (currentEvent != null) {
                              places.fetchPlace(currentEvent!.placeId!, fields: [PlaceField.Location]).then((value) {
                                var latlng = value.place!.latLng;
                                return gm.CameraPosition(target: gm.LatLng(latlng!.lat, latlng!.lng));
                              });
                            }

                            return _defaultPosition;
                          }),
                          initialData: _defaultPosition,
                          builder: (context, snapshot) {
                            return gm.GoogleMap(
                              onMapCreated: (controller) async {
                                _gmController.complete(controller);
                                (await _gmController.future).setMapStyle(_mapStyle);
                              },
                              initialCameraPosition: _defaultPosition,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                            );
                          },
                        ),
                      ),
                      if (currentEvent != null)
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            width: 22.w,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog<String>(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child: TextEditor(
                                                      information: "New Event",
                                                      textController: _eventTitle,
                                                    ),
                                                  );
                                                }).then((value) => setState(() {}));
                                          },
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _eventTitle.text,
                                              textAlign: TextAlign.start,
                                              textDirection: TextDirection.ltr,
                                              style: Theme.of(context).textTheme.titleLarge,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      if (currentEvent != null)
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          style: noBorderIconButtonStyle,
                                          onPressed: () {
                                            var event = currentEvent;
                                            deleteEvent(event!.key!);
                                            setState(() {
                                              currentEvent = null;
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                  Divider(),
                                  const SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Information",
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.location_pin),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                showDialog<String>(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: GooglePlacesTextField(
                                                          textController: _eventAddress,
                                                          placeId: _placeId,
                                                        ),
                                                      );
                                                    }).then((value) async {
                                                  setState(() {});
                                                  // (await _gmController.future).animateCamera(cameraUpdate);
                                                });
                                              },
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _eventAddress.text,
                                                  textAlign: TextAlign.start,
                                                  textDirection: TextDirection.ltr,
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text("Day 1", style: Theme.of(context).textTheme.titleMedium),
                                            style: eventWidgetButtonStyle,
                                          )),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: OutlinedButton(
                                            onPressed: () {
                                              showTimePicker(context: context, initialTime: start).then((value) {
                                                setState(() {
                                                  if (value != null) start = value;
                                                  end = TimeOfDay(hour: (start.hour + 1) % 24, minute: start.minute);
                                                });
                                              });
                                            },
                                            child: Text(Time(0, start.hour, start.minute).toTimeString(), style: Theme.of(context).textTheme.titleMedium),
                                            style: eventWidgetButtonStyle,
                                          )),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.arrow_right),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text("Day 1", style: Theme.of(context).textTheme.titleMedium),
                                            style: eventWidgetButtonStyle,
                                          )),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: OutlinedButton(
                                            onPressed: () {
                                              showTimePicker(context: context, initialTime: end).then((value) {
                                                setState(() {
                                                  if (value != null) end = value;
                                                });
                                              });
                                            },
                                            child: Text(Time(0, end.hour, end.minute).toTimeString(), style: Theme.of(context).textTheme.titleMedium),
                                            style: eventWidgetButtonStyle,
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(),
                                  const SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description",
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: _eventDescription,
                                        textAlignVertical: TextAlignVertical.top,
                                        minLines: 1,
                                        maxLines: 5,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  FilledButton(
                                    onPressed: () {
                                      var event = EventModel(
                                        tripKey: widget.tripKey,
                                        eventName: _eventTitle.text,
                                        address: _eventAddress.text,
                                        startTime: Time(0, start.hour, start.minute),
                                        endTime: Time(0, end.hour, end.minute),
                                        description: _eventDescription.text,
                                        placeId: _placeId.value,
                                      );
                                      updateEvent(event);
                                      setState(() {});
                                    },
                                    child: Text("Save"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class TrafficItem extends StatelessWidget {
  const TrafficItem({
    super.key,
    required this.distance,
    required this.duration,
    required this.summary,
  });

  final double distance;
  final Minutes duration;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: trafficWidgetButtonStyle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.directions_car),
                const SizedBox(width: 20),
                Text(
                  duration.toTime().toDurationString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 20),
                Text(
                  "${distance.toStringAsFixed(2)} mi",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Text(
              summary,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class DayChangeWidget extends StatelessWidget {
  const DayChangeWidget({
    super.key,
    required this.currentDay,
    required this.maxDay,
    required this.leftOnPressed,
    required this.rightOnPressed,
    required this.createOnPressed,
  });

  final int currentDay;
  final int maxDay;

  final Function() leftOnPressed;
  final Function() rightOnPressed;
  final Function() createOnPressed;

  @override
  Widget build(BuildContext context) {
    Widget left = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: currentDay > 1 ? leftOnPressed : null,
    );

    Widget right = currentDay < maxDay
        ? IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: rightOnPressed,
          )
        : IconButton(
            icon: const Icon(Icons.add),
            onPressed: createOnPressed,
          );

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          left,
          Text(
            "DAY $currentDay",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          right
        ],
      ),
    );
  }
}

class DayConfigurationRow extends StatelessWidget {
  DayConfigurationRow({super.key});

  final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(strokeColor)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
          style: buttonStyle,
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.swap_horiz),
          style: buttonStyle,
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
          style: buttonStyle,
        ),
      ],
    );
  }
}
