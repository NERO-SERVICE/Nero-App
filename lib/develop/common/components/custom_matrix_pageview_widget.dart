import 'package:flutter/material.dart';

class CustomMatrixPageviewWidget extends StatelessWidget {
  final PageController controller;
  final int itemCount;
  final Function(int) onPageChanged;
  final IndexedWidgetBuilder itemBuilder;
  final double horizontalPadding;
  final Color? backgroundColor;

  const CustomMatrixPageviewWidget({
    Key? key,
    required this.controller,
    required this.itemCount,
    required this.onPageChanged,
    required this.itemBuilder,
    this.horizontalPadding = 40,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: backgroundColor ?? Colors.transparent,
      child: PageView.builder(
        controller: controller,
        itemCount: itemCount,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxSize = constraints.biggest.shortestSide;
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: maxSize,
                      height: maxSize,
                      child: itemBuilder(context, index),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
