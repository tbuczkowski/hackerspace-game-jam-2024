import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';

class GamepadsInputTestPage extends StatefulWidget {
  const GamepadsInputTestPage({super.key});

  @override
  State<GamepadsInputTestPage> createState() => _GamepadsInputTestPageState();
}

class _GamepadsInputTestPageState extends State<GamepadsInputTestPage> {
  final List<GamepadEvent> _events = [];

  @override
  void initState() {
    Gamepads.events.listen(
      (GamepadEvent event) {
        print(event);
        setState(() {
          _events.add(event);
          if (_events.length > 20) _events.removeAt(0);
        });
      },
      onError: (Object error) {
        print(error);
      },
      onDone: () {
        print('done');
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: Gamepads.list(),
              builder: (BuildContext context, AsyncSnapshot<List<GamepadController>> snapshot) =>
                  Text('Connected gamepads: ${snapshot.data?.map((gamepad) => (gamepad.id, gamepad.name)) ?? []}'),
            ),
            Text('Events:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _events.reversed
                  .map((e) => Text((e.gamepadId, e.timestamp, e.type, e.key, e.value).toString()))
                  .toList(),
            )
          ],
        ),
      );
}
