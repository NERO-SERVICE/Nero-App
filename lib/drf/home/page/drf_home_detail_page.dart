import 'package:flutter/material.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';
import 'package:nero_app/drf/home/controller/drf_product_service.dart';

class DrfProductDetailPage extends StatefulWidget {
  final int productId;

  DrfProductDetailPage({required this.productId});

  @override
  _DrfProductDetailPageState createState() => _DrfProductDetailPageState();
}

class _DrfProductDetailPageState extends State<DrfProductDetailPage> {
  final DrfProductService _productService = DrfProductService();
  DrfProduct? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final product = await _productService.getProduct(widget.productId);
    setState(() {
      _product = product;
      _isLoading = false;
    });
  }

  Future<void> _updateProduct() async {
    if (_product != null) {
      final success = await _productService.updateProduct(_product!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product updated successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update product'),
        ));
      }
    }
  }

  Future<void> _deleteProduct() async {
    final success = await _productService.deleteProduct(widget.productId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product deleted successfully!'),
      ));
      Navigator.pop(context); // 삭제 후 목록 페이지로 돌아가기
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete product'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteProduct,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _product == null
          ? Center(child: Text('Product not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${_product!.title}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Description: ${_product!.description ?? 'No description'}'),
            SizedBox(height: 16),
            Text('Price: \$${_product!.productPrice}'),
            SizedBox(height: 16),
            Text('Status: ${_product!.status}'),
            SizedBox(height: 16),
            Text('Category: ${_product!.categoryType}'),
            Spacer(),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
