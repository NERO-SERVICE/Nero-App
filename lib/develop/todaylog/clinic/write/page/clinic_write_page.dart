import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';

import '../../../../common/components/app_font.dart';
import '../../../../common/components/calandar_widget.dart';
import '../../../../common/components/custom_submit_button.dart';
import '../../../../common/components/time_selection_widget.dart';
import '../../model/drug.dart';
import '../../model/drug_archive.dart';
import '../../model/my_drug_archive.dart';
import '../controller/clinic_write_controller.dart';

class ClinicWritePage extends StatefulWidget {
  @override
  _ClinicWritePageState createState() => _ClinicWritePageState();
}

class _ClinicWritePageState extends State<ClinicWritePage> {
  final _formKey = GlobalKey<FormState>();
  late ClinicWriteController controller;
  late TextEditingController _descriptionController;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ClinicWriteController());
    _descriptionController =
        TextEditingController(text: controller.clinic.value.description);
    _descriptionController.addListener(() {
      controller.changeDescription(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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
      isScrollControlled: true, // 모달의 크기를 유연하게 조정하기 위함
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min, // 내부 내용에 따라 크기를 자동으로 조절
                children: [
                  CalendarWidget(
                    initialSelectedDate: date.value,
                    initialFocusedDate: date.value,
                  ),
                  SizedBox(height: 16), // 원하는 만큼의 하단 여백 설정
                ],
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
    analytics.logScreenView(
      screenName: 'ClinicWritePage',
      screenClass: 'ClinicWritePage',
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(title: '진료기록'),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 21),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '처방받은 내용을 기록해주세요',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xffD9D9D9),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '최근 진료일',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDateSelector('Recent Day', controller.recentDay),
                  const SizedBox(height: 30),
                  _divider,
                  const SizedBox(height: 20),
                  Text(
                    '다음 예약 진료일',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDateSelector('Next Day', controller.nextDay),
                  const SizedBox(height: 30),
                  _divider,
                  const SizedBox(height: 20),
                  _registerDrug(),
                  const SizedBox(height: 20),
                  _buildDrugsList(),
                  const SizedBox(height: 30),
                  _divider,
                  _clinicDescription(),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: CustomSubmitButton(
                onPressed: () async {
                  await _submitForm();
                  CustomSnackbar.show(
                    context: context,
                    message: '진료 기록이 제출되었습니다.',
                    isSuccess: true,
                  );
                },
                text: '제출하기',
                isEnabled: true,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget get _divider => const Divider(
        color: Color(0xff3C3C3E),
        indent: 0,
        endIndent: 0,
      );

  Widget get _dialogDivider => Divider(
        color: Color(0xffD8D8D8).withOpacity(0.3),
        indent: 0,
        endIndent: 0,
      );

  Widget _buildDateSelector(String label, Rx<DateTime> date) {
    final RxBool isSelected = false.obs;

    return Obx(() {
      return GestureDetector(
        onTap: () async {
          isSelected.value = true;
          await _selectDate(context, date);
          isSelected.value = false;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected.value ? Color(0xffD0EE17) : Color(0xffD9D9D9),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy년 MM월 dd일').format(date.value),
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.calendar_today, size: 16, color: Color(0xffD9D9D9)),
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
                '${drug.myDrugArchive.drugName} ${drug.myDrugArchive.capacity}mg · ${drug.number}정 (${drug.time})',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              trailing: GestureDetector(
                onTap: () {
                  controller.removeDrug(index);
                },
                child: SvgPicture.asset(
                  'assets/develop/exit.svg',
                  width: 24, // 원하는 사이즈로 설정
                  height: 24, // 원하는 사이즈로 설정
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void _addDrugDialog(BuildContext context) {
    final drugNumberController = TextEditingController();
    final controller = Get.find<ClinicWriteController>();

    Rxn<DrugArchive> selectedArchive = Rxn<DrugArchive>();
    List<String> times = ['아침', '점심', '저녁'];
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
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            Text(
                              '종류',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            DrugArchiveDropdown(
                              selectedArchive: selectedArchive,
                              controller: controller,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      _dialogDivider,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              '개수',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField('개수', drugNumberController),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      _dialogDivider,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TimeSelectionWidget(selectedTime: selectedTime),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedArchive.value != null &&
                                drugNumberController.text.isNotEmpty) {
                              final myDrugArchive = MyDrugArchive(
                                myArchiveId: 1,
                                archiveId: selectedArchive.value!.archiveId,
                                drugName: selectedArchive.value!.drugName,
                                target: selectedArchive.value!.target,
                                capacity: selectedArchive.value!.capacity,
                              );

                              // Drug 생성
                              final drug = Drug(
                                drugId: 1,
                                // 새로 생성되므로 0으로 설정
                                myDrugArchive: myDrugArchive,
                                // 생성된 MyDrugArchive 사용
                                number: int.parse(drugNumberController.text),
                                initialNumber:
                                    int.parse(drugNumberController.text),
                                time: selectedTime.value,
                                allow: true,
                              );

                              controller.addDrug(drug);
                              Get.back();
                            } else {
                              CustomSnackbar.show(
                                context: Get.context!,
                                message: '모든 필드를 채워주세요.',
                                isSuccess: false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff323232),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 33),
                          ),
                          child: Text(
                            '등록하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xffD0EE17),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      cursorColor: Color(0xffD9D9D9),
      keyboardType: TextInputType.number,
      maxLength: 3,
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        color: Color(0xffFFFFFF),
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff3C3C3C),
        hintText: '숫자로 입력해주세요',
        hintStyle: TextStyle(
          fontSize: 14,
          color: Color(0xff959595),
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xffD0EE17), width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 13),
      ),
    );
  }

  Widget _clinicDescription() {
    return GetBuilder<ClinicWriteController>(
      builder: (controller) {
        return TextFormField(
          controller: _descriptionController,
          cursorColor: Color(0xffD9D9D9),
          decoration: InputDecoration(
            hintText: '이번 진료 중 특이사항을 작성해주세요',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Color(0xffD9D9D9),
          ),
          maxLines: 10,
        );
      },
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
          GetBuilder<ClinicWriteController>(
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

class DrugArchiveDropdown extends StatelessWidget {
  final Rxn<DrugArchive> selectedArchive;
  final ClinicWriteController controller;

  DrugArchiveDropdown({
    required this.selectedArchive,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField<DrugArchive>(
        menuMaxHeight: 200,
        dropdownColor: Color(0xff3C3C3C),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xff3C3C3C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xffD0EE17), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0), width: 1),
          ),
        ),
        value: selectedArchive.value,
        items: controller.drugArchives.map((archive) {
          return DropdownMenuItem<DrugArchive>(
            value: archive,
            child: Text(
              '${archive.drugName} (${archive.capacity}mg)',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xff959595),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedArchive.value = value;
        },
      );
    });
  }
}
