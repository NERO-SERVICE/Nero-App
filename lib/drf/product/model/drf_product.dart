import 'package:equatable/equatable.dart';
import 'package:nero_app/src/common/components/product_category_selector.dart';
import 'package:nero_app/src/common/enum/market_enum.dart';
import 'package:photo_manager/photo_manager.dart';

class DrfProduct extends Equatable {
  final int id;
  final String title;
  final String? description;
  final int productPrice;
  final bool isFree;
  final List<String> imageUrls;
  final int owner;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final String status;
  final List<dynamic>? wantTradeLocation;
  final String? wantTradeLocationLabel;
  final String categoryType;
  final List<int> likers;

  DrfProduct({
    this.id = 0, // 기본값 제공
    this.title = '',
    this.description,
    this.productPrice = 0, // 기본값 제공
    this.isFree = false, // 기본값 제공
    this.imageUrls = const [], // 기본값 제공
    this.owner = 0, // 기본값 제공
    this.nickname = '',
    required this.createdAt, // 이 필드는 여전히 필수로 설정
    required this.updatedAt, // 이 필드는 여전히 필수로 설정
    this.viewCount = 0, // 기본값 제공
    this.status = 'sale', // 기본값 제공
    this.wantTradeLocation,
    this.wantTradeLocationLabel,
    this.categoryType = 'General', // 기본값 제공
    this.likers = const [], // 기본값 제공
  });

  DrfProduct.empty()
      : id = 0,
        title = '',
        description = null,
        productPrice = 0,
        isFree = false,
        imageUrls = [],
        owner = 0,
        nickname = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        viewCount = 0,
        status = 'sale',
        wantTradeLocation = null,
        wantTradeLocationLabel = null,
        categoryType = '',
        likers = [];

  factory DrfProduct.fromJson(Map<String, dynamic> json) {
    return DrfProduct(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      productPrice: json['productPrice'] ?? 0,
      isFree: json['isFree'] ?? false,
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      owner: json['owner'] ?? 0,
      nickname: json['nickname'] ?? '',
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

  DrfProduct copyWith({
    String? title,
    String? description,
    int? owner,
    int? productPrice,
    int? viewCount,
    bool? isFree,
    List<String>? imageUrls,
    List<int>? likers,
    String? status,
    List<dynamic>? wantTradeLocation,
    String? wantTradeLocationLabel,
    String? categoryType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DrfProduct(
      id: id,
      title: title ?? this.title,
      owner: owner ?? this.owner,
      description: description ?? this.description,
      productPrice: productPrice ?? this.productPrice,
      isFree: isFree ?? this.isFree,
      viewCount: viewCount ?? this.viewCount,
      imageUrls: imageUrls ?? this.imageUrls,
      likers: likers ?? this.likers,
      status: status ?? this.status,
      wantTradeLocation: wantTradeLocation ?? this.wantTradeLocation,
      wantTradeLocationLabel:
      wantTradeLocationLabel ?? this.wantTradeLocationLabel,
      categoryType: categoryType ?? this.categoryType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
        nickname,
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
