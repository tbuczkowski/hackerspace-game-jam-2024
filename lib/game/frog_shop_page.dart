import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/audio/audio_controller.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:provider/provider.dart';

class FrogShopPage extends StatefulWidget {
  const FrogShopPage(this.gameRef, {super.key});

  final ASDGame gameRef;

  @override
  State<FrogShopPage> createState() => _FrogShopPageState(gameRef);
}

class _FrogShopPageState extends State<FrogShopPage> with SingleTickerProviderStateMixin {
  double opacity = 0;
  final ASDGame gameRef;

  _FrogShopPageState(this.gameRef);

  void toNextLevel() {
    gameRef.overlays.remove('frog_shop');
    gameRef.resumeEngine();
    GoRouter.of(context!).replace('/game_page');
  }

  @override
  Widget build(BuildContext context) {
    var windowSize = MediaQuery.of(context).size;
    return SizedBox.expand(
        child: Image(width: windowSize.width, height: windowSize.height,
        image: AssetImage('assets/images/frog_shop.png')));
  }
}
