import 'package:flutter/material.dart';
import 'package:travely/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/models/eventModel.dart';
import 'package:travely/models/time.dart';
import 'package:travely/services/firebaseDatabase.dart';
import 'package:travely/style.dart';

class DayViewPanel extends StatefulWidget {
  const DayViewPanel({Key? key, required this.tripKey}) : super(key: key);

  final String tripKey;

  @override
  State<DayViewPanel> createState() => _DayViewPanelState();
}

class _DayViewPanelState extends State<DayViewPanel> {
  late int _currentDay;
  late String _tripKey;

  @override
  void initState() {
    _tripKey = widget.tripKey;
    _currentDay = 1;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamEvents(_tripKey, _currentDay),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DayChangeWidget(
                currentDay: _currentDay,
                maxDay: 5,
                leftOnPressed: () {},
                rightOnPressed: () {},
                createOnPressed: () {},
              ),
              const SizedBox(height: 10),
              DayConfigurationRow(),
              const SizedBox(height: 20),
              Text(
                "Traffic data for March, 16",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              EventViewer(listOfEvents: snapshot.data!),
              EventItem(
                event: EventModel(
                  eventName: "Event 1",
                  startTime: Time(1, 15, 0),
                  endTime: Time(1, 17, 30),
                ),
              ),
              TrafficItem(distance: 14, duration: Minutes(10), summary: "This is summary"),
            ],
          );
        }

        return Text("Error");
      },
    );
  }
}

class EventViewer extends StatelessWidget {
  EventViewer({super.key, required this.listOfEvents});

  List<EventModel> listOfEvents;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          itemBuilder: ((context, index) {
            return EventItem(event: listOfEvents[index]);
          }),
          separatorBuilder: ((context, index) {
            return Divider();
          }),
          itemCount: listOfEvents.length,
        )
      ],
    );
  }
}

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
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
                  "$distance mi",
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
