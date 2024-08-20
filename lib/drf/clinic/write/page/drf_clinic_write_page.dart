import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/write/controller/drf_clinic_write_controller.dart';
import 'package:nero_app/drf/drf_calendar_widget.dart';
import 'package:nero_app/src/common/components/app_font.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: '제목'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  controller.titleController.text = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              Text(
                '최근 진료일',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              _buildDateSelector('Recent Day', controller.recentDay),
              const SizedBox(height: 20),
              Text(
                '다음 진료일',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              _buildDateSelector('Next Day', controller.nextDay),
              const SizedBox(height: 20),
              _buildDrugsList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _addDrugDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('약물 등록', style: TextStyle(fontSize: 18),),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffD0EE17),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('진료 기록 생성', style: TextStyle(fontSize: 18),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, Rx<DateTime> date) {
    return Obx(() {
      return GestureDetector(
        onTap: () => _selectDate(context, date),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('yyyy-MM-dd').format(date.value),
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
          return ListTile(
            title: Text('${drug.status} - ${drug.number} pills (${drug.time})',
            style: TextStyle(color: Colors.white, fontSize: 15),),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                controller.removeDrug(index);
              },
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
      '페로스핀 18mg'
    ];
    List<String> times = ['morning', 'lunch', 'dinner'];

    RxString selectedStatus = statuses[0].obs;
    RxString selectedTime = times[0].obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Drug'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdown('Status', statuses, selectedStatus),
              const SizedBox(height: 10),
              _buildTextField('Number', drugNumberController),
              const SizedBox(height: 10),
              _buildDropdown('Time', times, selectedTime),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final drug = DrfDrug(
                  drugId: 0,
                  clinicId: 0,
                  // 실제 clinicId는 서버에서 처리됨
                  status: selectedStatus.value,
                  // 문자열로 전달
                  number: int.parse(drugNumberController.text),
                  time: selectedTime.value, // 문자열로 전달
                );
                controller.addDrug(drug);
                Get.back();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown(
      String label, List<String> options, RxString selectedOption) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        value: selectedOption.value,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
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
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
