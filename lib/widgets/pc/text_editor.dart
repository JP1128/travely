import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:travely/constant.dart';
import 'package:travely/models/string_wrapper.dart';
import 'package:travely/models/wrapper.dart';
import 'package:travely/style.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({
    super.key,
    required this.information,
    required this.textController,
  });

  final String information;
  final TextEditingController textController;

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.information,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.textController,
              onEditingComplete: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GooglePlacesTextField extends StatefulWidget {
  const GooglePlacesTextField({
    super.key,
    required this.textController,
    required this.placeId,
  });

  final TextEditingController textController;
  final Wrapper<String?> placeId;

  @override
  State<GooglePlacesTextField> createState() => _GooglePlacesTextFieldState();
}

class _GooglePlacesTextFieldState extends State<GooglePlacesTextField> {
  TextEditingController controller = TextEditingController();
  List<AutocompletePrediction>? predictions;

  void placesAutocomplete(String query) async {
    final response = await places.findAutocompletePredictions(query);
    setState(() {
      this.predictions = response.predictions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 30.h,
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              onEditingComplete: () => placesAutocomplete(controller.text),
            ),
            if (predictions != null)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () {
                        widget.textController.text = predictions![index].fullText;
                        widget.placeId.value = predictions![index].placeId;
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        predictions![index].fullText,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: predictions!.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
