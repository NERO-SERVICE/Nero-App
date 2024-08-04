import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/components/trade_location_map.dart';
import 'package:nero_app/src/common/components/user_temperature_widget.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';
import 'package:nero_app/src/common/model/product.dart';
import 'package:nero_app/src/common/utils/data_util.dart';
import 'package:nero_app/src/product/detail/controller/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      body: SingleChildScrollView(
        child: Obx(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  final Product product;

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
          child: Row(
            children: List.generate(
              product.imageUrls?.length ?? 0,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: const Color(0xff212123)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final Product product;

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
                        product.owner?.nickname ?? '',
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
                        temperature: product.owner?.temperature ?? 36.7),
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
  final Product product;

  const _ProductDetail({super.key, required this.product});

  Widget _statistic() {
    return Row(
      children: [
        AppFont(
          '관심 ${product.likers?.length ?? 0}',
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
                    product.categoryType?.name ?? '',
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
  final Product product;

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200,
                    child: SimpleTradeLocationMap(
                      myLocation: product.wantTradeLocation!,
                      lable: product.wantTradeLocationLabel,
                      interactiveFlags: InteractiveFlag.pinchZoom,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(indent: 20, endIndent: 20, color: Color(0xff2C2C2E))
            ],
          )
        : Container();
  }
}
