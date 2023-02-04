import 'package:flutter/material.dart';
import 'package:travely/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/models/time.dart';
import 'package:travely/style.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({Key? key}) : super(key: key);

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "DAY #",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.swap_horiz),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Traffic data for March, 16",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          EventItem(eventTitle: "Event 1", startTime: Time(16, 00), endTime: Time(19, 30)),
          TrafficItem(distance: 10, duration: Time(0, 10), mode: ModeOfTransportation.DRIVING),
        ],
      ),
    );
  }
}

class EventViewer extends StatefulWidget {
  const EventViewer({super.key});

  @override
  State<EventViewer> createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: [
        EventItem(eventTitle: "Event 1", startTime: Time(16, 00), endTime: Time(19, 30)),
      ],
      onReorder: (int oldIndex, int newIndex) {},
    );
  }
}

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
    required this.eventTitle,
    required this.startTime,
    required this.endTime,
  });

  final String eventTitle;
  final Time startTime;
  final Time endTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      decoration: boxDecoration,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  Text(
                    startTime.toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    " - ",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    endTime.toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrafficItem extends StatelessWidget {
  const TrafficItem({
    super.key,
    required this.distance,
    required this.duration,
    required this.mode,
  });

  final double distance;
  final Time duration;
  final ModeOfTransportation mode;

  @override
  Widget build(BuildContext context) {
    Icon icon;

    switch (mode) {
      case ModeOfTransportation.DRIVING:
        icon = Icon(Icons.directions_car_rounded);
        break;
      case ModeOfTransportation.WALKING:
        icon = Icon(Icons.directions_walk_rounded);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: boxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            duration.toStringDuration(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 10),
          Text(
            "$distance mi",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          icon,
        ],
      ),
    );
  }
}
