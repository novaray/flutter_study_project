import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea( // 시스템 UI 피해서 UI 그리기(아이폰 노치에 대비)
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(),
            _CoupleImage(),
          ],
        )
      )
    );
  }
}

class _DDay extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
   final textTheme = Theme.of(context).textTheme;
   return Column(
     children: [
       const SizedBox(height: 16.0),
       Text(
         'U&I',
         style: textTheme.displayLarge,
       ),
       const SizedBox(height: 16.0),
       Text(
         '우리 처음 만난 날',
         style: textTheme.bodyLarge
       ),
       Text(
         '2021.01.10',
         style: textTheme.bodyMedium
       ),
       const SizedBox(height: 16.0),
       IconButton(
         iconSize: 60.0,
         onPressed: () {},
         icon: Icon(
           Icons.favorite,
           color: Colors.red,
         ),
       ),
       const SizedBox(height: 16.0),
       Text(
         'D+365',
         style: textTheme.displayMedium
       ),
     ],
   );
 }
}

class _CoupleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          'asset/image/middle_image.png',
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}