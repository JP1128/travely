import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/style.dart';
import 'package:travely/widgets/pc/day_view_panel.dart';
import 'package:travely/widgets/pc/mapFrame.dart';
import 'package:travely/widgets/pc/rightPanel.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 15.w,
            child: DayViewPanel(
              tripKey: "",
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Stack(
              children: [
                const MapFrame(),
                const Positioned(
                  right: 15,
                  top: 15,
                  child: RightPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
