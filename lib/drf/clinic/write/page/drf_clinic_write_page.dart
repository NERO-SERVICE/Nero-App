import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/write/controller/drf_clinic_write_controller.dart';
import 'package:nero_app/drf/common/time_selection_button_bar.dart';
import 'package:nero_app/drf/drf_calendar_widget.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/components/common_text_field.dart';
import 'package:nero_app/src/common/components/trade_location_map.dart';

class DrfClinicWritePage extends StatefulWidget {
  @override
  _DrfClinicWritePageState createState() => _DrfClinicWritePageState();
}

class _DrfClinicWritePageState extends State<DrfClinicWritePage> {
  final _formKey = GlobalKey<FormState>();
  late DrfClinicWriteController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DrfClinicWriteController());
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await controller.createClinic();
    }
  }

  Future<void> _selectDate(BuildContext context, Rx<DateTime> date) async {
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.all(16),
              height: 400,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: DrfCalendarWidget(
                selectedDate: date,
                focusedDate: date,
              ),
            ),
          ),
        );
      },
    );

    if (selectedDate != null && selectedDate != date.value) {
      date.value = selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.6,
        leading: Padding(
          padding: const EdgeInsets.only(),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
              constraints: BoxConstraints(),
            ),
            const AppFont(
              '진료 기록',
              fontWeight: FontWeight.bold,
              size: 20,
              color: Colors.white,
            ),
          ]),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ListView(
            children: [
              SizedBox(height: 18),
              Text(
                '처방받은 내용을 기록해주세요',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xffD9D9D9),
                ),
              ),
              const SizedBox(height: 46),
              _divider,
              _clinicTitleView(),
              _divider,
              const SizedBox(height: 18),
              _HopeTradeLocationMap(),
              const SizedBox(height: 18),
              _divider,
              const SizedBox(height: 18),
              Text(
                '최근 진료일',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              _buildDateSelector('Recent Day', controller.recentDay),
              const SizedBox(height: 18),
              _divider,
              const SizedBox(height: 18),
              Text(
                '다음 예약 진료일',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildDateSelector('Next Day', controller.nextDay),
              const SizedBox(height: 20),
              _divider,
              const SizedBox(height: 18),
              _registerDrug(),
              const SizedBox(height: 10),
              _buildDrugsList(),
              const SizedBox(height: 12),
              _divider,
              _clinicDescription(),
              _divider,
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    _submitForm;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('진료 기록이 제출되었습니다.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 66.0),
                  ),
                  child: Text(
                    '제출하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _divider => const Divider(
        color: Color(0xff3C3C3E),
        indent: 0,
        endIndent: 0,
      );

  Widget get _dialogDivider => const Divider(
        color: Color(0xffD9D9D9),
        indent: 0,
        endIndent: 0,
      );

  Widget _buildDateSelector(String label, Rx<DateTime> date) {
    return Obx(() {
      return GestureDetector(
        onTap: () => _selectDate(context, date),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('yyyy년 MM월 dd일').format(date.value),
                  style: TextStyle(color: Colors.white)),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDrugsList() {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.drugs.length,
        itemBuilder: (context, index) {
          final drug = controller.drugs[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Color(0xff1C1B1B),
              border: Border.all(
                color: Color(0xffD0EE17),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                '${drug.status} · ${drug.number}정 (${drug.time})',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  controller.removeDrug(index);
                },
              ),
            ),
          );
        },
      );
    });
  }

  void _addDrugDialog(BuildContext context) {
    final drugNumberController = TextEditingController();

    List<String> statuses = [
      '콘서타 18mg',
      '콘서타 27mg',
      '콘서타 36mg',
      '폭세틴 20mg',
      '메디카넷 18mg',
      '페로스핀 18mg',
    ];
    List<String> times = ['morning', 'lunch', 'dinner'];

    RxString selectedStatus = statuses[0].obs;
    RxString selectedTime = times[0].obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.5),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '종류',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildDropdown(statuses, selectedStatus),
                        const SizedBox(height: 27),
                        _dialogDivider,
                        const SizedBox(height: 18),
                        Text(
                          '개수',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildTextField('개수', drugNumberController),
                        const SizedBox(height: 27),
                        _dialogDivider,
                        const SizedBox(height: 18),
                        TimeSelectionWidget(selectedTime: selectedTime),
                        const SizedBox(height: 27),
                        _dialogDivider,
                        const SizedBox(height: 18),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              final drug = DrfDrug(
                                drugId: 0,
                                clinicId: 0,
                                status: selectedStatus.value,
                                number: int.parse(drugNumberController.text),
                                time: selectedTime.value,
                              );
                              controller.addDrug(drug);
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff323232),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 66.0,
                              ),
                            ),
                            child: Text(
                              '등록하기',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color(0xffD0EE17),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(List<String> options, RxString selectedOption) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        menuMaxHeight: 200,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 2),
          ),
        ),
        value: selectedOption.value,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedOption.value = value!;
        },
      );
    });
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffD9D9D9).withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0),
      ),
    );
  }

  Widget _clinicTitleView() {
    return GetBuilder<DrfClinicWriteController>(
      builder: (controller) {
        return CommonTextField(
          hintText: '글 제목',
          initText: controller.product.value.title,
          onChange: controller.changeTitle,
          hintColor: const Color(0xff6D7179),
        );
      },
    );
  }

  Widget _clinicDescription() {
    return GetBuilder<DrfClinicWriteController>(
      builder: (controller) {
        return CommonTextField(
          hintColor: Color(0xff6D7179),
          hintText: '이번 진료 중 특이사항을 작성해주세요',
          textInputType: TextInputType.multiline,
          maxLines: 10,
          initText: controller.product.value.description,
          onChange: controller.changeDescription,
        );
      },
    );
  }

  Widget _HopeTradeLocationMap() {
    return GestureDetector(
      onTap: () async {
        // TradeLocationMap 위젯에서 반환된 결과를 처리하는 부분
        var result = await Get.to<Map<String, dynamic>?>(
          TradeLocationMap(
            lable: controller.product.value.wantTradeLocationLabel,
            location: controller.product.value.wantTradeLocation != null &&
                    controller.product.value.wantTradeLocation!['latitude'] !=
                        null &&
                    controller.product.value.wantTradeLocation!['longitude'] !=
                        null
                ? LatLng(
                    controller.product.value.wantTradeLocation!['latitude']!,
                    controller.product.value.wantTradeLocation!['longitude']!,
                  )
                : null,
          ),
        );
        if (result != null) {
          controller.changeTradeLocationMap(result);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppFont(
            '진료 위치',
            size: 16,
            color: Colors.white,
          ),
          GetBuilder<DrfClinicWriteController>(
            builder: (controller) {
              return controller.product.value.wantTradeLocationLabel == null ||
                      controller.product.value.wantTradeLocationLabel!.isEmpty
                  ? Row(
                      children: [
                        const AppFont(
                          '장소선택',
                          size: 13,
                          color: Color(0xffD0EE17),
                        ),
                        SvgPicture.asset(
                          'assets/svg/icons/right.svg',
                          height: 24,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        AppFont(
                          controller.product.value.wantTradeLocationLabel ?? '',
                          size: 13,
                          color: Colors.white,
                        ),
                        GestureDetector(
                          onTap: () => controller.clearWantTradeLocation(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              'assets/svg/icons/delete.svg',
                              height: 24,
                            ),
                          ),
                        )
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _registerDrug() {
    return GestureDetector(
      onTap: () async {
        _addDrugDialog(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppFont(
            '약물 등록',
            size: 16,
            color: Colors.white,
          ),
          GetBuilder<DrfClinicWriteController>(
            builder: (controller) {
              return Row(
                children: [
                  const AppFont(
                    '선택하기',
                    size: 13,
                    color: Color(0xffD0EE17),
                  ),
                  SvgPicture.asset(
                    'assets/svg/icons/right.svg',
                    height: 24,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
