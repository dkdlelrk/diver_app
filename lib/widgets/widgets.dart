import 'dart:ffi';

import 'package:diver/data/getXState.dart';
import 'package:diver/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/getXStateAnimated.dart';
import '../main_screen.dart';
import '../notice_board_page.dart';

PreferredSizeWidget appbars(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    title: Text(
      Get.find<UserDataGetX>().pageIndex.value == 0 ? 'Main Screen' : 'NoticeBoard',
      style: TextStyle(color: Colors.white),
    ),
    centerTitle: true,
    elevation: 0,
    automaticallyImplyLeading: false,
    flexibleSpace: Container(
      color: Colors.black,
      /*decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),*/
    ),
    actions: [
      IconButton(
        color: Colors.white,
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpScreen();
                },
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error : $e'),
              ),
            );
          }
        },
        icon: const Icon(Icons.logout_rounded),
      ),
    ],
  );
}

Widget bottomSheet(BuildContext context) {
  void pageMove() {
    var page;

    switch (Get.find<UserDataGetX>().pageIndex.value) {
      case 0:
        page = const MainScreen();
        break;
      case 1:
        page = const NoticeBoardPage();
        break;
    }
    Navigator.of(context).push(pageAnimations(() => page));
  }

  return SafeArea(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: 70,
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bottomIconWithLabel(
            icon: Icons.arrow_back_ios_rounded, // previous page
            size: 25,

            onPressed: () {
              Get.find<UserDataGetX>().decrease();
              pageMove();
            },
            label: 'Back',
          ),
          _bottomIconWithLabel(
            icon: Icons.arrow_forward_ios_rounded, //next page
            size: 25,
            onPressed: () {
              Get.find<UserDataGetX>().indexIncrease();
              pageMove();
            },
            label: 'Next',
          ),
          Obx(
            () => _bottomIconWithLabel(
              onPressed: () {
                Get.put(AnimationsData()).isClick();
              },
              icon: Get.put(AnimationsData()).isFloatingButton.value //UpFloatingBtn
                  ? Icons.arrow_circle_up_rounded
                  : Icons.arrow_circle_down_rounded,
              label: 'Sub',
              size: 30,
            ),
          ),
          _bottomIconWithLabel(
            icon: Icons.home_outlined, //home
            onPressed: () {
              Get.find<UserDataGetX>().initIndex();
              pageMove();
            },
            label: 'Home',
            size: 30,
          ),
          Builder(
            builder: (context) => _bottomIconWithLabel(
              icon: Icons.format_list_bulleted_rounded, //draw
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              label: 'List',
              size: 30,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _bottomIconWithLabel({
  required IconData? icon,
  required VoidCallback onPressed,
  String label = '',
  required double size,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: size,
          color: Colors.white38,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.9),
    width: 215,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.5),
            child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Obx(
            () => Text(
              Get.find<UserDataGetX>().userNickName.value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            color: Colors.white24,
            height: 1.5,
            width: double.infinity,
          ),
          const SizedBox(height: 20),
          _buildDrawerOption(Icons.home, 'Home', () {
            Navigator.of(context).push(pageAnimations(() => const MainScreen()));
          }),
          _buildDrawerOption(Icons.photo, 'Memory', () {}),
          _buildDrawerOption(Icons.add_chart_outlined, 'Reservation', () {}),
          _buildDrawerOption(Icons.rate_review_outlined, 'Notice board', () {
            Navigator.of(context).push(pageAnimations(() => const NoticeBoardPage()));
          }),
          _buildDrawerOption(Icons.help, 'Help', () {}),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Version 1.0',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDrawerOption(IconData icon, String label, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 30, color: Colors.white),
        const SizedBox(width: 15),
        TextButton(
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Route pageAnimations(Function() page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
