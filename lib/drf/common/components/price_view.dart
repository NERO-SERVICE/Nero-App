import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/enum/market_enum.dart';

class PriceView extends StatelessWidget {
  final int price;
  final ProductStatusType status;

  const PriceView({super.key, required this.price, required this.status});

  Widget stateView() {
    Color backColor = Colors.green;
    Color textColor = Colors.white;
    switch (status) {
      case ProductStatusType.sale:
        return Container();
      case ProductStatusType.reservation:
        backColor = Colors.green;
        textColor = Colors.white;
        break;
      case ProductStatusType.soldOut:
      case ProductStatusType.cancel:
        backColor = Colors.grey;
        textColor = Colors.black;
        break;
    }
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: backColor,
      ),
      child: AppFont(
        status.name,
        size: 12,
        color: textColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return price == 0
        ? Row(
            children: [
              stateView(),
              const AppFont(
                '나눔',
                size: 14,
                fontWeight: FontWeight.bold,
              ),
              const AppFont(
                '♥',
                size: 16,
              )
            ],
          )
        : Row(
            children: [
              stateView(),
              AppFont(
                '${NumberFormat('###,###,###,###').format(price)}원',
                color: Colors.white,
                size: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          );
  }
}
