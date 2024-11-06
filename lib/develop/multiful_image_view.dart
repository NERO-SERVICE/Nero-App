import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import 'dart:ui';

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
  bool isSubmitting = false; // 완료 버튼 중복 클릭 방지용 플래그

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

  void _onSubmit() {
    if (!isSubmitting) {
      setState(() {
        isSubmitting = true;
      });
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
        setState(() {
          isSubmitting = false; // 이미지 선택이 없을 때 플래그 초기화
        });
      }
    }
  }

  bool containValue(AssetEntity value) {
    return selectedImages.any((element) => element.id == value.id);
  }

  Widget _photoWidget(AssetEntity asset) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              selectedImages.clear();
              selectedImages.add(asset);
              Get.back(result: selectedImages);
            },
            child: Container(
              decoration: BoxDecoration(
                border: containValue(asset)
                    ? Border.all(color: Color(0xffD0EE17), width: 4)
                    : null,
              ),
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
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
        automaticallyImplyLeading: false,
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
        toolbarHeight: 56.0,
        titleSpacing: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Text(
              '이미지 선택',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: isSubmitting ? null : _onSubmit,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  '완료',
                  style: TextStyle(
                    color: isSubmitting ? Colors.grey : Color(0xffD0EE17),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
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
          ),
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
