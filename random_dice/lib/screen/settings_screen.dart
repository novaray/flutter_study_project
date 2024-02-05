import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';

class SettingsScreen extends StatelessWidget {
  final double threshold; // slider의 현재값.
  final ValueChanged<double> onThresholdChanged; // slider의 값이 변경될 때 호출되는 콜백 함수.

  const SettingsScreen({
    required this.threshold,
    required this.onThresholdChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Text(
                '민감도',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          )
        ),
        Slider(
          min: 0.1,
          max: 10.0,
          divisions: 101,
          value: threshold,
          onChanged: onThresholdChanged,        // 값 변경 시 실행되는 함수
          label: threshold.toStringAsFixed(1),  // 표시값
        )
      ],
    );
  }
}