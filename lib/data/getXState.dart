import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDataGetX extends GetxController {
  var userList = <dynamic>[].obs;
  var userNickName = ''.obs;
  var userAutoLogin = false.obs;
  var pageIndex = 0.obs;
  var isLoading = false.obs;
  var isFirstAutoLogin = false.obs;

  Future<void> userDataFetch(BuildContext context) async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      final currentUser = FirebaseAuth.instance.currentUser;

      final currentUserData = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();

      userList.value = querySnapshot.docs.map((doc) => doc.data()).toList();
      userNickName.value = currentUserData.data()!['NickName'];
    } catch (e) {
      debugPrint('Error fetching user data: ${e.toString()}');
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no.')),
      );*/
    } finally {
      isLoading.value = false;
    }
  }

  void indexIncrease() {
    pageIndex.value += 1;
    if (pageIndex.value > 1) {
      pageIndex.value = 1;
    }
  }

  void decrease() {
    pageIndex.value -= 1;
    if (pageIndex.value < 0) {
      pageIndex.value = 0;
    }
  }

  void initIndex() {
    pageIndex.value = 0;
  }

  Future<void> isSwitchChanged(bool value) async {
    isFirstAutoLogin.value = value;
    debugPrint(value.toString());
    await saveAutoLoginPreference(value);
  }

  Future<void> saveAutoLoginPreference(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    //if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'isAutoLogin': value,
      }, SetOptions(merge: true));
      debugPrint('Data save success: ');
    } catch (e) {
      debugPrint('Data save Fail: $e');
    }
  }

  Future<void> loadAutoLoginPreference() async {
    final user = FirebaseAuth.instance.currentUser;
    //if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists && doc.data() != null) {
        isFirstAutoLogin.value = doc.data()!['isAutoLogin'] ?? false;
      }
    } catch (e) {
      debugPrint('자동 로그인 설정 불러오기 실패: $e');
    }
  }
}
