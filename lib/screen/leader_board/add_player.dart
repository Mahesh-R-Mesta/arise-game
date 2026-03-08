import 'package:arise_game/game/bloc/coin_cubit.dart';
import 'package:arise_game/service/connectivity.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/toast.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class AddPlayerToLeaderBoard extends StatefulWidget {
  const AddPlayerToLeaderBoard({super.key});

  @override
  State<AddPlayerToLeaderBoard> createState() => _AddPlayerToLeaderBoardState();
}

class _AddPlayerToLeaderBoardState extends State<AddPlayerToLeaderBoard> {
  final playerNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fToast = FToast();
    fToast.init(context);
    final duration = const Duration(milliseconds: 300);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppAsset.logo, width: 80.h, height: 80.h),
                    SizedBox(height: 16.h),
                    Text(
                      'PLAYER NAME',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22.sp,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      controller: playerNameController,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                      validator: (text) => text?.isNotEmpty == true ? null : "Please enter player name",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: 'Enter name...',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.white38,
                          fontSize: 16.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WoodenButton(
                          size: Size(120.w, 45.h),
                          text: 'CANCEL',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        WoodenButton(
                          size: Size(120.w, 45.h),
                          text: 'SUBMIT',
                          onTap: () {
                            final validPlayerName = _formKey.currentState?.validate() ?? false;
                            if (!validPlayerName) return;
                            
                            NetworkConnection.isConnected().then((connected) {
                              if (!connected) {
                                ToastMessage(message: "No internet connection! please try again").show();
                              }
                            });
                            
                            LocalStorage.instance.setPlayerName = playerNameController.text.trim();
                            final database = GetIt.I.get<LeaderboardDatabase>();
                            final earnedCoinCubit = context.read<EarnedCoinCubit>();
                            database.registerPlayerScore(playerNameController.text.trim(), earnedCoinCubit.state);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fade(duration: duration, curve: Curves.easeOutCubic)
              .scale(duration: duration, curve: Curves.easeOutCubic, begin: const Offset(0.8, 0.8)),
        ),
      ),
    );
  }
}
