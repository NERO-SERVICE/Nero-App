import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/home/controller/drf_product_service.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';

class DrfHomeWritePage extends StatefulWidget {
  @override
  _DrfHomeWritePageState createState() => _DrfHomeWritePageState();
}

class _DrfHomeWritePageState extends State<DrfHomeWritePage> {
  final _formKey = GlobalKey<FormState>();
  final DrfProductService _productService = DrfProductService();

  String? _title;
  String? _description;
  int _price = 0;
  bool _isFree = false;
  String? _categoryType = 'General';
  String? _status = 'sale';
  String? _wantTradeLocationLabel;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Product 생성하기
      final newProduct = DrfProduct(
        id: 0, // ID는 서버에서 생성
        title: _title ?? '',
        description: _description,
        productPrice: _price,
        isFree: _isFree,
        imageUrls: [], // 이미지 URL은 비워둠
        owner: 1, // 예시로 유저 ID를 지정
        nickname: '유저',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        viewCount: 0,
        status: _status!,
        wantTradeLocation: [], // 위치 정보
        wantTradeLocationLabel: _wantTradeLocationLabel,
        categoryType: _categoryType!,
        likers: [],
      );

      final createdProduct = await _productService.createProduct(newProduct);

      if (createdProduct != null) {
        Get.back(); // 게시물 작성 후 이전 페이지로 돌아가기
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product created successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create product.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = int.tryParse(value ?? '0') ?? 0;
                },
              ),
              SwitchListTile(
                title: Text('Is Free'),
                value: _isFree,
                onChanged: (value) {
                  setState(() {
                    _isFree = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: _categoryType,
                items: <String>[
                  'General',
                  'Electronics',
                  'Clothing',
                  'Home',
                  'Toys',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryType = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Status'),
                value: _status,
                items: <String>[
                  'sale',
                  'reservation',
                  'soldOut',
                  'cancel',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Trade Location Label'),
                onSaved: (value) {
                  _wantTradeLocationLabel = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
