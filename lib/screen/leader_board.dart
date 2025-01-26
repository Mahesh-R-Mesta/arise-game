import 'dart:ui';

import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';

class LeaderBoardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {'name': 'Player1', 'score': 1500},
    {'name': 'Player2', 'score': 1200},
    {'name': 'Player3', 'score': 1000},
    {'name': 'Player4', 'score': 800},
    {'name': 'Player5', 'score': 600},
    {'name': 'Player2', 'score': 1200},
    {'name': 'Player3', 'score': 1000},
    {'name': 'Player4', 'score': 800},
    {'name': 'Player5', 'score': 600},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.9,
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppAsset.sunRise), fit: BoxFit.fill)),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: SizedBox.expand()),
            ),
          ),
          Positioned(
              top: 10,
              left: 10,
              child: WoodenSquareButton(
                  size: Size.square(58),
                  onTap: () => Navigator.of(context).pop(),
                  widget: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 33,
                  ))),
          Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  width: 200,
                  child: Card(
                      color: Colors.black38,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('Top Players',
                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      )))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Card(
                      color: Colors.black38,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          player['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          '${player['score']}',
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
