import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/style.dart';
import 'package:travely/widgets/pc/leftPanel.dart';
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
          const LeftPanel(),
          const SizedBox(width: 20),
          Expanded(
            child: Stack(
              children: [
                MapFrame(),
                Positioned(
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
