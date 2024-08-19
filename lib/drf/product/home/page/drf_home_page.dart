import 'package:flutter/material.dart';
import 'package:nero_app/drf/product/list/page/drf_product_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrfHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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
