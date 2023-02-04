import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/pages/pc/mainPage.dart';
import 'package:travely/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Travely - PC',
          theme: theme,
          home: Material(
            child: const MainPage(),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
