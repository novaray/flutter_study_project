import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;    // 사용할 탭 컨트롤러 선언
  double threshold = 2.7;       // 민감도 기본값
  int number = 1;               // 주사위 숫자
  ShakeDetector? shakeDetector; // 흔들림 감지기

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);  // 탭 컨트롤러 초기화
    controller!.addListener(tabListener);  // 탭 컨트롤러 리스너 추가

    shakeDetector = ShakeDetector.autoStart(
      shakeSlopTimeMS: 100,  // 흔들림 감지 시간
      shakeThresholdGravity: threshold,  // 흔들림 감지 민감도
      onPhoneShake: onPhoneShake
    );
  }

  void onPhoneShake() {
    final random = new Random();

    setState(() {
      number = random.nextInt(5) + 1;
    });
  }

  tabListener() {
    setState(() {

    });
  }

  @override
  void dispose() {
    controller!.removeListener(tabListener);
    shakeDetector!.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,  // 탭 컨트롤러 연결
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(number: number),
      SettingsScreen(
          threshold: threshold,
          onThresholdChanged: onThresholdChange
      ),
    ];
  }

  void onThresholdChange(double value) {
    setState(() {
      threshold = value;
    });
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: controller!.index,  // 현재 선택된 탭 인덱스
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.edgesensor_high_outlined,
          ),
          label: '주사위'
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
          ),
          label: '설정'
        ),
    ]);
  }
}