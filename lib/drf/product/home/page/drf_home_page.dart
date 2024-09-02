import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/product/list/page/drf_product_list_page.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrfHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        leadingWidth: Get.width * 0.6,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              const AppFont(
                'NERO',
                fontWeight: FontWeight.bold,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('accessToken');
              await prefs.remove('refreshToken');
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: DrfProductListPage(),
    );
  }
}
