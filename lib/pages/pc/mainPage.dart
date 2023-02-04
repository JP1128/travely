import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/widgets/pc/mainFrame.dart';
import 'package:travely/widgets/pc/topBar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 50,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15.w,
                  child: Image.asset(
                    "assets/logo.png",
                    height: 60,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(child: TopBar()),
              ],
            ),
            SizedBox(height: 30),
            Expanded(child: MainFrame()),
          ],
        ),
      ),
    );
  }
}
