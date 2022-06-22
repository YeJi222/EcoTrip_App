import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widget.dart';

class TimePage extends StatefulWidget {
  const TimePage({Key? key}) : super(key: key);

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  late final ScrollController verticalController;
  late final ScrollController horizontalController;

  @override
  void initState() {
    super.initState();
    verticalController = ScrollController();
    horizontalController = ScrollController();
  }

  @override
  void dispose() {
    verticalController.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  final items = <TimelineItem>[
    TimelineItem(
      startDateTime: DateTime(1970, 1, 1, 7),
      endDateTime: DateTime(1970, 1, 1, 8, 0),
      position: 0,
      child: const Event(title: 'Event Monday'),
    ),
    TimelineItem(
      startDateTime: DateTime(1970, 1, 1, 10),
      endDateTime: DateTime(1970, 1, 1, 12),
      position: 1,
      child: const Event(title: 'Event Wednesday'),
    ),
    TimelineItem(
      startDateTime: DateTime(1970, 1, 1, 15),
      endDateTime: DateTime(1970, 1, 1, 17),
      position: 2,
      child: const Event(title: 'Event Friday'),
    ),
  ];

  int count = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly timetable'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Scrollbar(
            thumbVisibility: true,
            controller: horizontalController,
            child: Scrollbar(
              controller: verticalController,
              child: SingleChildScrollView(
                controller: horizontalController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: verticalController,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 60),
                          ...List.generate(
                            count,
                                (index) => DayHeader(day: index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DynamicTimeline(
                        firstDateTime: DateTime(1970, 01, 01, 7),
                        lastDateTime: DateTime(1970, 01, 01, 22),
                        labelBuilder: DateFormat('HH:mm').format,
                        intervalDuration: const Duration(hours: 1),
                        crossAxisCount: count,
                        intervalExtent: 50,
                        items: items,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DayHeader extends StatelessWidget {
  const DayHeader({
    Key? key,
    required this.day,
  }) : super(key: key);

  final int day;

  @override
  Widget build(BuildContext context) {
    late final String dayString;

    switch (day) {
      case 0:
        dayString = 'Monday';
        break;
      case 1:
        dayString = 'Tuesday';
        break;
      case 2:
        dayString = 'Wednesday';
        break;
      case 3:
        dayString = 'Thursday';
        break;
      case 4:
        dayString = 'Friday';
        break;
      case 5:
        dayString = 'Saturday';
        break;
      case 6:
        dayString = 'Sunday';
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 20),
      width: 100,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(dayString),
    );
  }
}