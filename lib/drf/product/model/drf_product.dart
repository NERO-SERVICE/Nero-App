import 'package:equatable/equatable.dart';

class DrfProduct extends Equatable {
  final int id;
  final String title;
  final String? description;
  final int productPrice;
  final bool isFree;
  final List<String> imageUrls;
  final int owner;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final String status;
  final List<dynamic>? wantTradeLocation;
  final String? wantTradeLocationLabel;
  final String categoryType;
  final List<int> likers;

  DrfProduct({
    required this.id,
    required this.title,
    this.description,
    required this.productPrice,
    required this.isFree,
    required this.imageUrls,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
    required this.viewCount,
    required this.status,
    this.wantTradeLocation,
    this.wantTradeLocationLabel,
    required this.categoryType,
    required this.likers,
  });

  factory DrfProduct.fromJson(Map<String, dynamic> json) {
    return DrfProduct(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      productPrice: json['productPrice'] ?? 0,
      isFree: json['isFree'] ?? false,
      imageUrls: (json['imageUrls'] as List<dynamic>).map((e) => e.toString()).toList(),
      owner: json['owner'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      viewCount: json['viewCount'] ?? 0,
      status: json['status'] ?? 'sale',
      wantTradeLocation: json['wantTradeLocation'],
      wantTradeLocationLabel: json['wantTradeLocationLabel'],
      categoryType: json['categoryType'] ?? '',
      likers: (json['likers'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'productPrice': productPrice,
      'isFree': isFree,
      'imageUrls': imageUrls,
      'owner': owner,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'viewCount': viewCount,
      'status': status,
      'wantTradeLocation': wantTradeLocation,
      'wantTradeLocationLabel': wantTradeLocationLabel,
      'categoryType': categoryType,
      'likers': likers,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    productPrice,
    isFree,
    imageUrls,
    owner,
    createdAt,
    updatedAt,
    viewCount,
    status,
    wantTradeLocation,
    wantTradeLocationLabel,
    categoryType,
    likers,
  ];
}
