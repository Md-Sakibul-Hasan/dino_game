import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ebs/post_repository/ebs_post_repo.dart';
import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/main_menu.dart';
import '/models/player_data.dart';
import '/game/audio_manager.dart';

// This represents the game over overlay,
// displayed with dino runs out of lives.
class GameOverMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'GameOverMenu';

  // Reference to parent game.
  final DinoRun game;
  final String userId;

  const GameOverMenu(this.game, {super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    print("dino run userid=$userId");
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black.withAlpha(100),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    const Text(
                      'Game Over',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    Selector<PlayerData, int>(
                      selector: (_, playerData) => playerData.currentScore,
                      builder: (_, score, __) {
                        return Text(
                          'You Score: $score',
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        );
                      },
                    ),
                    Selector<PlayerData, int>(
                      selector: (_, playerData) => playerData.currentScore,
                      builder: (_, score, __) {
                        return ElevatedButton(
                          child: const Text(
                            'Restart',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          onPressed: () async {
                            game.overlays.remove(GameOverMenu.id);
                            game.overlays.add(Hud.id);
                            game.resumeEngine();
                            game.reset();
                            game.startGamePlay();
                            AudioManager.instance.resumeBgm();
                            await EbsPostRepo.postScoreData(gameScore: score, userId: userId);

                          },
                        );
                      },
                    ),
                    Selector<PlayerData, int>(
                      selector: (_, playerData) => playerData.currentScore,
                      builder: (_, score, __) {
                        return ElevatedButton(
                          child: const Text(
                            'Exit',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          onPressed: () async{
                            game.overlays.remove(GameOverMenu.id);
                            game.overlays.add(MainMenu.id);
                            game.resumeEngine();
                            game.reset();
                            AudioManager.instance.resumeBgm();
                            await EbsPostRepo.postScoreData(gameScore: score, userId: userId);
                          },
                        );
                      },
                    ),
                    // ElevatedButton(
                    //   child: const Text(
                    //     'Restart',
                    //     style: TextStyle(
                    //       fontSize: 30,
                    //     ),
                    //   ),
                    //   onPressed: () async {
                    //     game.overlays.remove(GameOverMenu.id);
                    //     game.overlays.add(Hud.id);
                    //     game.resumeEngine();
                    //     game.reset();
                    //     game.startGamePlay();
                    //     AudioManager.instance.resumeBgm();
                    //     await EbsPostRepo.postScoreData(gameScore: gameScore, userId: userId);
                    //
                    //   },
                    // ),
                    // ElevatedButton(
                    //   child: const Text(
                    //     'Exit',
                    //     style: TextStyle(
                    //       fontSize: 30,
                    //     ),
                    //   ),
                    //   onPressed: () async{
                    //     game.overlays.remove(GameOverMenu.id);
                    //     game.overlays.add(MainMenu.id);
                    //     game.resumeEngine();
                    //     game.reset();
                    //     AudioManager.instance.resumeBgm();
                    //    await EbsPostRepo.postScoreData(gameScore: gameScore, userId: userId)
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
