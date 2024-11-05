// lib/develop/home/community/pages/multiful_image_view.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class MultifulImageView extends StatefulWidget {
  final List<AssetEntity>? initImages;

  const MultifulImageView({
    Key? key,
    this.initImages,
  }) : super(key: key);

  @override
  State<MultifulImageView> createState() => _MultifulImageViewState();
}

class _MultifulImageViewState extends State<MultifulImageView> {
  final ScrollController scrollController = ScrollController();
  List<AssetPathEntity> albums = [];
  int currentPage = 0;
  int lastPage = -1;
  List<AssetEntity> imageList = [];
  List<AssetEntity> selectedImages = [];

  @override
  void initState() {
    super.initState();
    loadMyPhotos();
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var currentScroll = scrollController.offset;
      if (currentScroll > maxScroll - 150 && currentPage != lastPage) {
        lastPage = currentPage;
        _pagingPhotos();
      }
    });
    if (widget.initImages != null) {
      selectedImages.addAll([...widget.initImages!]);
    }
  }

  void loadMyPhotos() async {
    var permissionState = await PhotoManager.requestPermissionExtend();
    if (permissionState.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            needTitle: true,
            sizeConstraint: SizeConstraint(
              minWidth: 800,
              minHeight: 800,
            ),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );
      _pagingPhotos();
    } else {
      // 권한 거부 시 설정으로 유도
      PhotoManager.openSetting();
    }
  }

  Future<void> _pagingPhotos() async {
    if (albums.isNotEmpty) {
      var photos = await albums.first.getAssetListPaged(page: currentPage, size: 60);
      if (currentPage == 0) {
        imageList.clear();
      }
      if (photos.isEmpty) {
        return;
      }

      setState(() {
        imageList.addAll(photos);
        currentPage += 1;
      });
    }
  }

  bool containValue(AssetEntity value) {
    return selectedImages.any((element) => element.id == value.id);
  }

  String returnIndexValue(AssetEntity value) {
    var index = selectedImages.indexWhere((element) => element.id == value.id);
    if (index == -1) return '';
    return (index + 1).toString();
  }

  void _selectedImage(AssetEntity asset) {
    setState(() {
      if (containValue(asset)) {
        selectedImages.removeWhere((element) => element.id == asset.id);
      } else {
        if (selectedImages.length < 10) {
          selectedImages.add(asset);
        } else {
          // 최대 선택 수 초과 시 메시지 표시
          Get.snackbar(
            '알림',
            '이미지는 최대 10개까지 선택 가능합니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      }
    });
  }

  Widget _photoWidget(AssetEntity asset) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                top: 0,
                child: Stack(children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      color: containValue(asset) ? Colors.white.withOpacity(0.5) : Colors.transparent,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        _selectedImage(asset);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: containValue(asset) ? Color(0xffED7738) : Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            returnIndexValue(asset),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            ],
          );
        } else {
          return Container(
            color: Colors.grey[300],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 선택'),
        actions: [
          GestureDetector(
            onTap: () {
              if (selectedImages.isNotEmpty) {
                Get.back(result: selectedImages);
              } else {
                Get.snackbar(
                  '알림',
                  '선택된 이미지가 없습니다.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 20.0, right: 25),
              child: Text(
                '완료',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              itemCount: imageList.length,
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return _photoWidget(imageList[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
