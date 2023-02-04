import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:travely/style.dart';

CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

class MapFrame extends StatefulWidget {
  const MapFrame({Key? key}) : super(key: key);

  @override
  State<MapFrame> createState() => _MapFrameState();
}

class _MapFrameState extends State<MapFrame> {
  late GoogleMapController _gmController;
  late String _mapStyle;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('mapStyle.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      clipBehavior: Clip.hardEdge,
      child: GoogleMap(
        onMapCreated: (controller) {
          _gmController = controller;
          _gmController.setMapStyle(_mapStyle);
        },
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
