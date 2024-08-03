import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:nero_app/src/common/enum/market_enum.dart';

class Product extends Equatable {
  final String? title;
  final String? description;
  final int? productPrice;
  final bool? isFree;
  final ProductCategoryType? categoryType;
  final LatLng? wantTradeLocation;
  final String? wantTradeLocationLabel;

  const Product({
    this.title,
    this.description,
    this.productPrice = 0,
    this.isFree,
    this.categoryType = ProductCategoryType.none,
    this.wantTradeLocation,
    this.wantTradeLocationLabel,
  });

  Map<String, dynamic> toMAp() {
    return {
      'title': title,
      'description': description,
      'productPrice': productPrice,
      'isFree': isFree,
      'categoryType': categoryType?.code,
      'wantTradeLocation': [
        wantTradeLocation?.latitude,
        wantTradeLocation?.longitude,
      ],
      'wantTradeLocationLabel': wantTradeLocationLabel,
    };
  }

  factory Product.fromJson(String docId, Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'],
      productPrice: json['productPrice'],
      isFree: json['isFree'],
      categoryType: json['categoryType'] == null
          ? ProductCategoryType.none
          : ProductCategoryType.findByCode(json['categoryType']),
      wantTradeLocationLabel: json['wantTradeLocationLabel'],
      wantTradeLocation: json['wantTradeLocation'] != null &&
              json['wantTradeLocation'][0] != null &&
              json['wantTradeLocation'][1] != null
          ? LatLng(json['wantTradeLocation'][0], json['wantTradeLocation'][1])
          : null,
    );
  }

  Product copyWith({
    String? title,
    String? description,
    int? productPrice,
    bool? isFree,
    ProductCategoryType? categoryType,
    LatLng? wantTradeLocation,
    String? wantTradeLocationLabel,
  }) {
    return Product(
      title: title ?? this.title,
      description: description ?? this.description,
      productPrice: productPrice ?? this.productPrice,
      isFree: isFree ?? this.isFree,
      categoryType: categoryType ?? this.categoryType,
      wantTradeLocation: wantTradeLocation ?? this.wantTradeLocation,
      wantTradeLocationLabel:
          wantTradeLocationLabel ?? this.wantTradeLocationLabel,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        productPrice,
        isFree,
        categoryType,
        wantTradeLocation,
        wantTradeLocationLabel,
      ];
}
