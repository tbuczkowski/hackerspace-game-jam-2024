import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/audio/audio_controller.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/style/my_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import 'game_state.dart';

class FrogShopPage extends StatefulWidget {
  const FrogShopPage(this.gameRef, {super.key});
  final ASDGame gameRef;

  @override
  State<FrogShopPage> createState() => _FrogShopPageState(gameRef);
}

class _FrogShopPageState extends State<FrogShopPage> with SingleTickerProviderStateMixin {
  double opacity = 0;
  final ASDGame gameRef;
  int intermissionStep = 0;
  String dialogText = "";
  List<int> boughtProducts = [];

  _FrogShopPageState(this.gameRef);
  late final GameState _state;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _state = await GameState.getInstance();
      var musicPlayer = gameRef.audioController.musicPlayer;
      await musicPlayer.stop();
      await musicPlayer.play(AssetSource('music/A Brief Respite (Camp Theme).mp3'));
    });
    super.initState();
  }

  void progressDialog(String newDialog) {
    setState(() {
      dialogText = newDialog;
    });
  }

  void toNextStage() async {
    gameRef.overlays.remove('frog_shop');
    GoRouter.of(context!).replace('/game_page');
    boughtProducts.clear();
    await gameRef.audioController.musicPlayer.stop();
  }

  TypewriterAnimatedText TypedAnimation(String content) {
    return TypewriterAnimatedText(
        content,
        textStyle: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.black,
          fontSize: 35
        ),
        speed: const Duration(milliseconds: 50));
  }

  Container ProductToBuy(String spritePath, Function onBuy, Function affectPlayer) {
    return Label(
        InkWell(
          onTap: () {
            onBuy();
            affectPlayer();
          },
          child: Image(
            image: AssetImage(spritePath),
          ),
        )
      );
  }

  Widget PriceLabel(int price){
    return TextLabel("$price\$");
  }

  Container Label(Widget content){
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      child: Container(
        color: Colors.green,
        width: 100,
        height: 100,
        child: SizedBox(
          width: 50,
          height: 50,
          child: content,
        ),
      ),
    );
  }

  Widget TextLabel(String value) {
    return Label(
      Center(
        child: Text(value,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      )
    );
  }

  Widget HpLabel() {
    var hp = gameRef.health;
    return TextLabel("HP: $hp");
  }

  Widget MoneyLabel() {
    var score = gameRef.currentScore;
    return TextLabel("Score: $score");
  }

  Widget PointLabel() {
    var currentFrogPoints = gameRef.currentFrogPoints;
    return TextLabel("Żapp points: $currentFrogPoints");
  }

  int calculateMultiplier() {
    if(boughtProducts.contains(0)
        && boughtProducts.contains(1)
        && boughtProducts.contains(2)) {
      return 2;
    }
    return 1;
  }

  void BuyProduct(int price, int index) {
    var saleMultiplies = calculateMultiplier();
    if(price <= gameRef.currentScore) {
      gameRef.currentScore -= price;
      gameRef.currentFrogPoints += price * saleMultiplies;
      boughtProducts.add(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/frog_shop.png'))
          ),
          Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              alignment: Alignment.bottomCenter,
              child: MyButton(child: Text("Continue Journey"), onPressed: () => toNextStage())
          ),
          Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topLeft,
                  child: Image(
                    width: 200,
                    height: 200,
                    image: AssetImage('assets/images/frogg_merchant.gif'),
                  ),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    color: Colors.blueGrey,
                    height: 200,
                    width: 500,
                    child: AnimatedTextKit(
                      repeatForever: false,
                      totalRepeatCount: 1,
                      pause: Duration(seconds: 2),
                      animatedTexts: [
                        TypedAnimation(""),
                        TypedAnimation("I am sorry, we are out of hotdogs, Wariacie"),
                        TypedAnimation("Try in the next Frogg Shop. It shouldn't be far."),
                        TypedAnimation("Best of luck, traveler. Maybe a Monster Energy Drincc?"),
                        TypedAnimation("Remember about our today's sale: buy each product, and you will get twice żapp points for each next purchase"),
                        TypedAnimation("")
                      ],
                    ))
              ],
            ),
            Row(
              children: [
                HpLabel(),
                MoneyLabel(),
                PointLabel()
              ],
            ),
            Row(
              children: [
                ProductToBuy(
                  "assets/images/shop/monsterek.png",
                  () => BuyProduct(2, 0),
                  () => setState(() {
                    gameRef.health = min(gameRef.health + 2, ASDGame.maxHealth);
                    _state.timeLeft += 10;
                  })
                ),
                ProductToBuy(
                  "assets/images/shop/specek.png",
                  () => BuyProduct(4, 1),
                  () => setState(() => gameRef.currentFrogPoints += 2)),
                ProductToBuy(
                  "assets/images/shop/szlugi.png",
                  () => BuyProduct(7, 2),
                  () => setState(() {
                    gameRef.currentFrogPoints += 5;
                    gameRef.health -= 1;
                  }))
              ],
            ),
            Row(
              children: [
                PriceLabel(2),
                PriceLabel(4),
                PriceLabel(7)
              ],
            )
          ],)
        ],
      ),
    );
  }
}
