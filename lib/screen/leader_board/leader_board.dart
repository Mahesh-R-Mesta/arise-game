import 'dart:core';
import 'dart:ui';
import 'package:arise_game/model/player_rank.dart';
import 'package:arise_game/service/connectivity.dart';
import 'package:arise_game/service/leaderboard_database.dart';
import 'package:arise_game/util/constant/assets_constant.dart';
import 'package:arise_game/util/widget/wooden_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with Blur
          Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAsset.sunRise),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _buildLeaderboardList(),
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 15.h,
            left: 15.w,
            child: WoodenSquareButton(
              size: Size.square(55.w),
              onTap: () => Navigator.of(context).pop(),
              widget: Icon(Icons.arrow_back, color: Colors.white, size: 30.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Text(
            'LEADERBOARD',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4,
              shadows: [
                Shadow(color: Colors.black.withValues(alpha: 0.5), offset: const Offset(2, 2), blurRadius: 4),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
          SizedBox(height: 8.h),
          Container(
            height: 2.h,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white54, Colors.transparent],
              ),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return FutureBuilder(
      future: GetIt.I.get<LeaderboardDatabase>().loadUserScores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white70));
        }

        if (snapshot.hasError || !snapshot.hasData || (snapshot.data as List).isEmpty) {
          return _buildErrorState();
        }

        final players = snapshot.data!;
        return ListView.builder(
          itemCount: players.length,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
          itemBuilder: (context, index) {
            final player = players[index];
            return _buildPlayerTile(player, index)
                .animate()
                .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                .slideX(begin: 0.1, curve: Curves.easeOutCubic);
          },
        );
      },
    );
  }

  Widget _buildPlayerTile(PlayerRank player, int index) {
    final bool isTop3 = index < 3;
    final Color rankColor = _getRankColor(index);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isTop3 ? rankColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isTop3 ? rankColor.withValues(alpha: 0.5) : Colors.white10,
          width: isTop3 ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: rankColor, width: 2),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),

          // Player Name
          Expanded(
            child: Text(
              player.name.isNotEmpty ? player.name : 'Unknown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: isTop3 ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Score
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(GameAssets.coin, width: 22.h, height: 22.h),
              SizedBox(width: 8.w),
              Text(
                player.amount.toString(),
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'VCR',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.white24;
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: FutureBuilder(
        future: NetworkConnection.isConnected(),
        builder: (ctx, data) {
          if (data.data == false) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: Colors.white54, size: 60.sp),
                SizedBox(height: 16.h),
                Text(
                  "No Internet Connection",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Please check your network settings",
                  style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                ),
              ],
            );
          }
          return Text(
            "No players found yet.\nBe the first to rank!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 16.sp, height: 1.5),
          );
        },
      ),
    );
  }
}
