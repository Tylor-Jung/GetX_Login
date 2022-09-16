import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_login/login.dart';
import 'package:getx_login/welcome_page.dart';

// GETX로 로그인기능 구현 기본 설정 => 앱 내 모든 위치에서 유저 정보 획득
class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth authencication = FirebaseAuth.instance;
  final userName = '';

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(authencication.currentUser); // 유저 변수 초기화
    _user.bindStream(
        authencication.userChanges()); // 유저 환경과 관계없이(로그인, 로그아웃 등) 언제든 유저 디테일 추적
    ever(_user, _moveToPage); //지속적으로 유저의 행동에 따른 이벤트 감지
  }

// 사용자의 행동에 따라 다른 페이지로 이동시키는 기능
  _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => WelcomePage());
    }
  }

  Future signUp(String email, password) async {
    try {
      final newUser = await authencication.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore.instance
          .collection('user')
          .doc(newUser.user!.uid)
          .set({'user name': userName});
    } catch (e) {
      Get.snackbar(
        'Error message',
        'User messgae',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          'Registration is failed.',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void login(String email, password) async {
    try {
      authencication.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar(
        'Error message',
        'User messgae',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          'signin is failed.',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void logout() {
    authencication.signOut();
  }
}
