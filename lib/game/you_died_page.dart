import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/audio/audio_controller.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:provider/provider.dart';

class YouDiedPage extends StatefulWidget {
  const YouDiedPage({super.key});

  @override
  State<YouDiedPage> createState() => _YouDiedPageState();
}

class _YouDiedPageState extends State<YouDiedPage> with SingleTickerProviderStateMixin {
  double opacity = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioController>().playSfx(SfxType.youDied, () {
        GoRouter.of(context).go('/');
      });
      setState(() {
        opacity = 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 1500),
      child: SizedBox.expand(
        child: const Material(
          color: Colors.black,
          child: Center(
            child: Image(image: AssetImage('assets/images/youdied.jpg')),
          ),
        ),
      ),
    );
  }
}
