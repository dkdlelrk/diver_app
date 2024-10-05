import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diver/data/getXState.dart';
import 'package:diver/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'data/getXStateAnimated.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  final animationsData = Get.put(AnimationsData());
  @override
  void initState() {
    Get.find<UserDataGetX>().userDataFetch(context);
    Get.put(AnimationsData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbars(context),
      drawer: buildDrawer(context),
      body: LayoutBuilder(
        builder: (context, pos) {
          return Stack(
            children: [
              Container(
                width: pos.maxWidth,
                height: pos.maxHeight,
                color: Colors.black,
                /*decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),*/
              ),
              Obx(
                () => AnimatedPositioned(
                  //up
                  duration: const Duration(milliseconds: 850),
                  curve: Curves.easeOutBack,
                  bottom: animationsData.isFloatingButton.value ? pos.maxHeight * 0.1 : pos.maxHeight * 0.01,
                  right: pos.maxWidth * 0.4,
                  //0.4 == half, 0.01 == maxMin
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 30),
                    opacity: animationsData.isFloatingButton.value ? 1 : 0.0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.white70,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                //left
                () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOutBack,
                  bottom: animationsData.isFloatingButton.value ? pos.maxHeight * 0.1 : pos.maxHeight * 0.01,
                  right: animationsData.isFloatingButton.value ? pos.maxWidth * 0.6 : pos.maxWidth * 0.4,
                  //0.4 == half, 0.01 == maxMin
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: animationsData.isFloatingButton.value ? 1 : 0.0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_card_rounded,
                        color: Colors.white70,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                //right
                () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  bottom: animationsData.isFloatingButton.value ? pos.maxHeight * 0.1 : pos.maxHeight * 0.01,
                  right: animationsData.isFloatingButton.value ? pos.maxWidth * 0.22 : pos.maxWidth * 0.4,
                  //0.4 == half, 0.01 == maxMin
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: animationsData.isFloatingButton.value ? 1 : 0.0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.ac_unit,
                        color: Colors.white70,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
              _userInfo(),
            ],
          );
        },
      ),
      bottomSheet: bottomSheet(context),
    );
  }

  Widget _userInfo() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var userData = users[index].data() as Map<String, dynamic>;
            final nickName = userData.containsKey('NickName') ? userData['NickName'] : 'No Name';
            final email = userData.containsKey('Email') ? userData['Email'] : 'No Email';

            // flutter_animate를 사용하여 애니메이션 추가
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Text(
                    nickName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  nickName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  'Email: $email',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 500))
                .slideY(begin: 0.3); // fadeIn과 slideY 애니메이션 적용
          },
        );
      },
    );
  } //userInfo
}

/*Widget afterUseSpeedDial() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 90, right: 0),
    child: SpeedDial(
      animatedIcon: AnimatedIcons.arrow_menu,
      foregroundColor: Colors.white,
      overlayColor: Colors.deepPurpleAccent,
      overlayOpacity: 0.5,
      activeBackgroundColor: Colors.deepPurpleAccent,
      backgroundColor: Colors.deepPurpleAccent,
      direction: SpeedDialDirection.left,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.ac_unit),
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.ac_unit),
          //label:  ,
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.ac_unit),
          //label:  ,
          onTap: () {},
        ),
      ],
    ),
  );
}*/ // SpeedDial
