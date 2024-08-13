import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/drf/clinic/detail/drf_clinic_detail_page.dart';
import 'package:nero_app/drf/clinic/model/drf_clinic.dart';
import 'package:nero_app/drf/clinic/repository/drf_clinic_repository.dart';
import 'package:nero_app/drf/clinic/write/page/drf_clinic_write_page.dart';
import 'package:nero_app/src/common/components/app_font.dart';

class DrfClinicListPage extends StatefulWidget {
  @override
  _DrfClinicListPageState createState() => _DrfClinicListPageState();
}

class _DrfClinicListPageState extends State<DrfClinicListPage> {
  final DrfClinicRepository _clinicRepository = DrfClinicRepository();
  List<DrfClinic> _clinics = [];

  @override
  void initState() {
    super.initState();
    _loadClinics();
  }

  Future<void> _loadClinics() async {
    try {
      final clinics = await _clinicRepository.getClinics();
      setState(() {
        _clinics = clinics;
      });
    } catch (e) {
      print('Failed to load clinics: $e');
    }
  }

  Widget _subInfo(DrfClinic clinic) {
    return Row(
      children: [
        AppFont(
          "유저 ${clinic.owner}",
          color: const Color(0xff878B93),
          size: 12,
        ),
        const AppFont(
          ' · ',
          color: Color(0xff878B93),
          size: 12,
        ),
        AppFont(
          DateFormat('yyyy.MM.dd').format(clinic.recentDay),
          color: const Color(0xff878B93),
          size: 12,
        ),
      ],
    );
  }

  Widget _clinicItem(DrfClinic clinic) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => DrfClinicDetailPage(clinic: clinic));
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/images/default.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                AppFont(
                  clinic.title,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(height: 5),
                _subInfo(clinic),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinics'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(left: 25.0, top: 20, right: 25),
        itemCount: _clinics.length,
        itemBuilder: (context, index) {
          final clinic = _clinics[index];
          return _clinicItem(clinic);
        },
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(
            color: Color(0xff3C3C3E),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => DrfClinicWritePage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
