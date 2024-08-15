import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/product/detail/controller/drf_product_detail_controller.dart';
import 'package:nero_app/drf/product/model/drf_product.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/components/scroll_appbar.dart';
import 'package:nero_app/src/common/components/user_temperature_widget.dart';
import 'package:nero_app/src/common/utils/data_util.dart';

class DrfProductDetailPage extends GetView<DrfProductDetailController> {
  const DrfProductDetailPage({super.key});

  void _showActionSheet(BuildContext context) {
    var actions = controller.isMine
        ? [
            CupertinoActionSheetAction(
              onPressed: () async {
                var isNeedRefresh =
                    await Get.toNamed('/product/write', parameters: {
                  'product_doc_id': controller.product.value.id.toString(),
                });
                if (isNeedRefresh != null &&
                    isNeedRefresh is bool &&
                    isNeedRefresh) {
                  controller.refresh();
                }
              },
              child: const Text('게시물 수정'),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                Get.back();
                var isDeleted = await showDialog<bool?>(
                  context: Get.context!,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: const AppFont(
                        '정말 삭제하시겠습니까?',
                        color: Colors.black,
                        size: 16,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            var result = await controller.deleteProduct();
                            Get.back(result: result);
                          },
                          child: const AppFont(
                            '삭제',
                            size: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        TextButton(
                          onPressed: Get.back,
                          child: const AppFont(
                            '취소',
                            size: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (isDeleted != null && isDeleted) {
                  Get.back(result: isDeleted);
                }
              },
              child: const Text('삭제'),
            ),
          ]
        : [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('게시물 신고'),
            ),
          ];
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollAppbarWidget(
      onBack: () {
        Get.back();
      },
      actions: [
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset('assets/svg/icons/share.svg'),
          ),
        ),
        GestureDetector(
          onTap: () {
            _showActionSheet(context);
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset('assets/svg/icons/more_vertical.svg'),
          ),
        ),
        const SizedBox(width: 10),
      ],
      body: Obx(
        () => Column(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.width,
              child: _ProductThumbnail(
                product: controller.product.value,
              ),
            ),
            _ProfileSection(product: controller.product.value),
            _ProductDetail(product: controller.product.value),
            _HopeTradeLocation(product: controller.product.value),
            _UserProducts(
              product: controller.product.value,
              ownerOtherProducts: controller.ownerOtherProducts.value,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  final DrfProduct product;

  const _ProductThumbnail({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: Get.size.width - 40,
            viewportFraction: 1,
            aspectRatio: 0,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 3),
            enableInfiniteScroll: true,
            disableCenter: true,
            onScrolled: (value) {},
            onPageChanged: (int index, _) {},
          ),
          items: List.generate(
            product.imageUrls?.length ?? 0,
            (index) => CachedNetworkImage(
              imageUrl: product.imageUrls![index],
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                value: downloadProgress.progress,
                strokeWidth: 1,
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 20,  // Adjust the position to move the indicator to the bottom
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              product.imageUrls?.length ?? 0,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white,),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final DrfProduct product;

  const _ProfileSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return product.owner == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      Image.asset('assets/images/default_profile.png').image,
                  backgroundColor: Colors.black,
                  radius: 23,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppFont(
                        product.owner.toString(),
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      const AppFont(
                        '송파 어딘가',
                        size: 13,
                        color: Color(0xffABAEB6),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UserTemperatureWidget(
                        temperature: product.owner.toDouble() ?? 36.7),
                    const SizedBox(height: 5),
                    const AppFont(
                      '매너온도',
                      decoration: TextDecoration.underline,
                      color: Color(0xff878B93),
                      size: 12,
                    )
                  ],
                )
              ],
            ),
          );
  }
}

class _ProductDetail extends StatelessWidget {
  final DrfProduct product;

  const _ProductDetail({super.key, required this.product});

  Widget _statistic() {
    return Row(
      children: [
        AppFont(
          '관심 ${product.likers.length ?? 0}',
          size: 12,
          color: const Color(0xff878B93),
        ),
        const AppFont(
          ' · ',
          size: 12,
          color: Color(0xff878B93),
        ),
        AppFont(
          '조회 ${product.viewCount}',
          size: 12,
          color: const Color(0xff878B93),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFont(
            product.title ?? '',
            size: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (product.categoryType != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AppFont(
                    product.categoryType ?? '',
                    size: 12,
                    color: const Color(0xff878B93),
                    decoration: TextDecoration.underline,
                  ),
                ),
              AppFont(
                MarketDataUtils.timeagoValue(
                    product.createdAt ?? DateTime.now()),
                size: 12,
                color: const Color(0xff878B93),
              ),
            ],
          ),
          const SizedBox(height: 30),
          AppFont(
            product.description ?? '',
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(height: 30),
          _statistic(),
        ],
      ),
    );
  }
}

class _HopeTradeLocation extends StatelessWidget {
  // 지도 거래 장소
  final DrfProduct product;

  const _HopeTradeLocation({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return product.wantTradeLocation != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppFont(
                      '거래 희망 장소',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      size: 15,
                    ),
                    GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.translucent,
                      child: SvgPicture.asset('assets/svg/icons/right.svg'),
                    ),
                  ],
                ),
              ),
              const Divider(indent: 20, endIndent: 20, color: Color(0xff2C2C2E))
            ],
          )
        : Container();
  }
}

class _UserProducts extends StatelessWidget {
  final DrfProduct product;
  final List<DrfProduct> ownerOtherProducts;

  const _UserProducts(
      {super.key, required this.product, required this.ownerOtherProducts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppFont(
                '${product.owner}님의 판매 상품',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                size: 15,
              ),
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.translucent,
                child: SvgPicture.asset('assets/svg/icons/right.svg'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: (ownerOtherProducts.length.clamp(0, 6) * 0.5).ceil() * 220,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.85,
            children: List.generate(
              ownerOtherProducts.length.clamp(0, 6),
              (index) => GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: ownerOtherProducts[index].imageUrls!.isEmpty
                          ? const SizedBox(
                              height: 120,
                              child: Center(child: Icon(Icons.error)))
                          : SizedBox(
                              height: 120,
                              child: CachedNetworkImage(
                                imageUrl:
                                    ownerOtherProducts[index].imageUrls!.first,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    strokeWidth: 1,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 15),
                    AppFont(
                      ownerOtherProducts[index].title ?? '',
                      maxLine: 1,
                      size: 14,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}