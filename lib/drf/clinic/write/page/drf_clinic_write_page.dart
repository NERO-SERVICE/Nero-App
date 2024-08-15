import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/drf/clinic/model/drf_drug.dart';
import 'package:nero_app/drf/clinic/write/controller/drf_clinic_write_controller.dart';

class DrfClinicWritePage extends StatefulWidget {
  @override
  _DrfClinicWritePageState createState() => _DrfClinicWritePageState();
}

class _DrfClinicWritePageState extends State<DrfClinicWritePage> {
  final _formKey = GlobalKey<FormState>();
  final DrfClinicWriteController controller = Get.put(DrfClinicWriteController());

  String? _title;
  DateTime _recentDay = DateTime.now();
  DateTime _nextDay = DateTime.now().add(Duration(days: 7));

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      await controller.createClinic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Clinic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
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
              _buildDateSelector('Recent Day', controller.recentDay),
              const SizedBox(height: 20),
              _buildDateSelector('Next Day', controller.nextDay),
              const SizedBox(height: 20),
              _buildDrugsList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addDrugDialog(context),
                child: Text('Add Drug'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Clinic'),
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
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: date.value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != date.value) {
            date.value = pickedDate;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('yyyy-MM-dd').format(date.value)),
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
            title: Text('${drug.status} - ${drug.number} pills (${drug.time})'),
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

    List<String> statuses = ['콘서타 18mg', '콘서타 27mg', '콘서타 36mg', '메디카넷 18mg', '페로스핀 18mg'];
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
                  clinicId: 0, // 실제 clinicId는 서버에서 처리됨
                  status: selectedStatus.value, // 문자열로 전달
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

  Widget _buildDropdown(String label, List<String> options, RxString selectedOption) {
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
