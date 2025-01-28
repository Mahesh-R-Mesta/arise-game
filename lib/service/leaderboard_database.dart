import 'package:arise_game/model/player_rank.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';

class LeaderboardDatabase {
  final String keyPath = "leader_board";

  registerPlayerScore(String playerName, int score) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    DatabaseReference reference = FirebaseDatabase.instance.ref(keyPath);
    await reference.child(deviceInfo.id.replaceAll('.', '-')).set({"name": playerName, "score": score});
  }

  Future<List<PlayerRank>> loadUserScores() async {
    final database = FirebaseDatabase.instance.ref();
    final databaseEvent = await database.child(keyPath).orderByChild("score").limitToLast(100).once();
    List<PlayerRank> players = [];
    Map<Object?, Object?>? mapData = databaseEvent.snapshot.value as Map<Object?, Object?>?;
    if (mapData == null) return [];
    final data = mapData.cast<String, dynamic>();
    players = data.keys.map((key) => PlayerRank(id: key, name: data[key]["name"], amount: data[key]["score"])).toList();
    players.sort((p1, p2) => p2.amount.compareTo(p1.amount));
    return players;
  }
}
