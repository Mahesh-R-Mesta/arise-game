import 'dart:core';
import 'dart:ui';
import 'package:arise_game/service/connectivity.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.9,
            child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppAsset.sunRise), fit: BoxFit.fill)),
                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: SizedBox.expand())),
          ),
          Positioned(
              top: 10,
              left: 10,
              child: WoodenSquareButton(
                  size: Size.square(55),
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
                child: FutureBuilder(
                    future: GetIt.I.get<LeaderboardDatabase>().loadUserScores(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: FutureBuilder(
                              future: NetworkConnection.isConnected(),
                              builder: (ctx, data) {
                                final loader = CircularProgressIndicator();
                                if (!data.hasData) return loader;
                                return data.data == false
                                    ? Text(" Please check yor internet connection ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900, fontSize: 19, color: Colors.white, backgroundColor: Colors.black38))
                                    : loader;
                              }),
                        );
                      }
                      final players = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: players.length,
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return Card(
                            color: Colors.black38,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              onTap: () {},
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
                                player.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(GameAssets.coin, width: 25, height: 25),
                                  Text(
                                    player.amount.toString(),
                                    style: const TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
