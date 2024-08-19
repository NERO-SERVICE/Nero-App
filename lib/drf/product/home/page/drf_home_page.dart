import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/product/list/page/drf_product_list_page.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrfHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.6,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(children: [
            const AppFont(
              '홈',
              fontWeight: FontWeight.bold,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
          ]),
        ),
        actions: [
          SvgPicture.asset('assets/svg/icons/search.svg'),
          const SizedBox(width: 15),
          SvgPicture.asset('assets/svg/icons/list.svg'),
          const SizedBox(width: 15),
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
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
