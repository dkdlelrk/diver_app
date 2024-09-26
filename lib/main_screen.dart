import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diver/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // flutter_animate 패키지 추가

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List userList = [];
  String userNickName = '';

  @override
  void initState() {
    super.initState();
    userDataFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Main Screen'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
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
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _userInfo(),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20), // 양쪽에 여백 추가
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
            // 배경에 그라데이션 추가
            gradient: const LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              // 그림자 효과 추가
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 균등 배치
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _bottomIconWithLabel(
                icon: Icons.arrow_back_ios_rounded,
                onPressed: () {},
                label: 'Back',
              ),
              _bottomIconWithLabel(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: () {},
                label: 'Next',
              ),
              _bottomIconWithLabel(
                icon: Icons.format_list_bulleted_rounded,
                onPressed: () {},
                label: 'List',
              ),
              _bottomIconWithLabel(
                icon: Icons.home_outlined,
                onPressed: () {},
                label: 'Home',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomIconWithLabel({
    required IconData? icon,
    required VoidCallback onPressed,
    required String label,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(height: 4), // 아이콘과 텍스트 사이 간격
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8), // 반투명한 흰색으로 텍스트 스타일
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
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
            Text(
              userNickName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              color: Colors.white24,
              height: 1.5,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            _buildDrawerOption(Icons.home, 'Home', () {}),
            _buildDrawerOption(Icons.photo, 'Memory', () {}),
            _buildDrawerOption(Icons.add_chart_outlined, 'Reservation', () {}),
            _buildDrawerOption(Icons.rate_review_outlined, 'Notice board', () {}),
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
  }

  void userDataFetch() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      final currentUser = FirebaseAuth.instance.currentUser;
      final currentUserData = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      setState(() {
        userList = querySnapshot.docs.map((doc) => doc.data()).toList();
        userNickName = currentUserData.data()!['NickName'];
      });
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch initial data: $e')),
      );
    }
  }
}
