import 'package:flutter/material.dart';
import 'package:travely/style.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: boxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            style: noBorderIconButtonStyle,
          ),
          TextButton(
            child: Text(
              "Trip Title",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
          Text(
            "# Days",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Expanded(child: Container()),
          FilledButton(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(Icons.delete, size: 20),
                SizedBox(width: 10),
                Text("Delete"),
              ],
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color(0xFF6D6D6D),
              ),
            ),
          ),
          const SizedBox(width: 20),
          FilledButton(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(Icons.share, size: 20),
                SizedBox(width: 10),
                Text("Share"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
