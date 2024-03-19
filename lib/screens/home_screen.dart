import 'package:flutter/material.dart';
import 'package:tictac_game/models/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X', result = '';
  bool isSwitched = false, gameOver = false;
  int turn = 0;
  Game game = Game();

  onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
    } // لا يظهر النتيجة في حالة التعادل، الحل هو إضافة الشرط التالي

    if (!isSwitched && !gameOver && turn != 9) {
      if (Player.playerX.length + Player.playerO.length < 9) {
        game.autoPlay(activePlayer);
        updateState();
      }
    } else if (isSwitched && !gameOver) {
      if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
          (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
        game.playGame(index, activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (turn == 9 && winnerPlayer.isEmpty) {
        result = 'It\'s a draw';
        gameOver = true;
      } else if (winnerPlayer.isNotEmpty) {
        result = winnerPlayer == 'X' ? ' X is the winner' : ' O is the winner';
        gameOver = true;
      }
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isSwitched ? 'Play with Computer' : 'Play with Friend',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isSwitched == false
                              ? isSwitched = true
                              : isSwitched = false;
                          Player.playerX.clear();
                          Player.playerO.clear();
                          result = '';
                          gameOver = false;
                        });
                      },
                      icon:
                          // add switch icon between the Computer and Friend icons
                          Icon(
                        isSwitched ? Icons.monitor_sharp : Icons.people,
                        color: Colors.white,
                        size: 30,
                      ))
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'It\'s $activePlayer turn',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 52,
              ),
              textAlign: TextAlign.center,
            ),
            // add game board here
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.count(
                  padding: const EdgeInsets.all(0.0),
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                  children: List.generate(9, (index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: gameOver ? null : () => onTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            Player.playerX.contains(index)
                                ? 'X'
                                : Player.playerO.contains(index)
                                    ? 'O'
                                    : '',
                            style: TextStyle(
                              color: Player.playerX.contains(index)
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 52,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Text(
              'Player : $result',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).splashColor,
                ),
              ),
              onPressed: () {
                setState(() {
                  Player.playerX.clear();
                  Player.playerO.clear();
                  result = '';
                  gameOver = false;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Restart'),
            )
          ],
        ),
      ),
    );
  }
}
