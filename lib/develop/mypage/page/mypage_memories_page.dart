import 'package:flutter/material.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';

class MypageMemoriesPage extends StatefulWidget {
  const MypageMemoriesPage({super.key});

  @override
  State<MypageMemoriesPage> createState() => _MypageMemoriesPageState();
}

class _MypageMemoriesPageState extends State<MypageMemoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: '챙길거리'),
      body: Column(
      ),
    );
  }
}
