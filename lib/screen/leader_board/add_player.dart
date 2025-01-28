import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/service/connectivity.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class AddPlayerToLeaderBoard extends StatefulWidget {
  const AddPlayerToLeaderBoard({super.key});

  @override
  State<AddPlayerToLeaderBoard> createState() => _AddPlayerToLeaderBoardState();
}

class _AddPlayerToLeaderBoardState extends State<AddPlayerToLeaderBoard> {
  final playerNameController = TextEditingController();
  final _formKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    final fToast = FToast();
    fToast.init(context);
    return Center(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(AssetSvg.woodBoard,
                    width: MediaQuery.of(context).size.width * 0.5, placeholderBuilder: (ctx) => CircularProgressIndicator())),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                // backgroundColor: Color(0XFFbd885a),
                title: Text(
                  'Enter Player Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: TextFormField(
                  key: _formKey,
                  controller: playerNameController,
                  validator: (text) => text?.isNotEmpty == true ? null : "Please enter player name",
                  decoration: InputDecoration(hintText: 'Player Name', border: UnderlineInputBorder()),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      final validPlayerName = _formKey.currentState?.validate() ?? false;
                      if (!validPlayerName) return;
                      NetworkConnection.isConnected().then((connected) {
                        if (!connected) ToastMessage(message: "No internet connection! please try again").show();
                      });
                      final database = GetIt.I.get<LeaderboardDatabase>();
                      final earnedCoinCubit = context.read<EarnedCoinCubit>();
                      database.registerPlayerScore(playerNameController.text, earnedCoinCubit.state);
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
