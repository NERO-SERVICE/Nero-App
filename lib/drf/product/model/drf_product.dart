import 'package:equatable/equatable.dart';

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
  final Map<String, double>? wantTradeLocation; // Map to hold latitude and longitude
  final String? wantTradeLocationLabel;
  final String categoryType;
  final List<int> likers;

  DrfProduct({
    this.id = 0,
    this.title = '',
    this.description,
    this.productPrice = 0,
    this.isFree = false,
    this.imageUrls = const [],
    this.owner = 0,
    this.nickname = '',
    required this.createdAt,
    required this.updatedAt,
    this.viewCount = 0,
    this.status = 'sale',
    this.wantTradeLocation = const {},
    this.wantTradeLocationLabel,
    this.categoryType = 'General',
    this.likers = const [],
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
        wantTradeLocation = const {},
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
      wantTradeLocation: json['wantTradeLocation'] != null
          ? {
        'latitude': json['wantTradeLocation']['latitude'],
        'longitude': json['wantTradeLocation']['longitude'],
      }
          : null,
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
      'wantTradeLocation': {
        'latitude': wantTradeLocation!['latitude'],
        'longitude': wantTradeLocation!['longitude'],
      },
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
    Map<String, double>? wantTradeLocation, // CopyWith for the Map
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
