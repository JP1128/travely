import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/constant.dart';
import 'package:travely/pages/pc/mainPage.dart';
import 'package:travely/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_directions_api/google_directions_api.dart' as gd;

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  gd.DirectionsService.init(GOOGLE_API);

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
          home: const Material(
            child: MainPage(),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
