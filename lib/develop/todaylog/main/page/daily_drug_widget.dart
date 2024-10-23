import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';

import '../../../common/components/custom_complete_button.dart';
import '../../clinic/model/drug.dart';
import '../../clinic/repository/clinic_repository.dart';

class DailyDrugWidget extends StatefulWidget {
  final DateTime recentDay;

  DailyDrugWidget({required this.recentDay});

  @override
  _DailyDrugWidgetState createState() => _DailyDrugWidgetState();
}

class _DailyDrugWidgetState extends State<DailyDrugWidget> {
  late Future<List<Drug>> _drugsFuture;
  final List<int> _selectedDrugIds = [];
  final ClinicRepository _clinicRepository = ClinicRepository();
  String? _rollbackDate; // recentDay에 따라 설정
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _drugsFuture = _loadDrugs();
    _rollbackDate = DateFormat('yyyy-MM-dd').format(widget.recentDay);
  }

  void _toggleDrugSelection(int drugId) {
    setState(() {
      if (_selectedDrugIds.contains(drugId)) {
        _selectedDrugIds.remove(drugId);
      } else {
        _selectedDrugIds.add(drugId);
      }
    });
  }

  Future<List<Drug>> _loadDrugs() async {
    try {
      return await _clinicRepository.getDrugsFromLatestClinic();
    } catch (e) {
      print('Error loading drugs: $e');
      return [];
    }
  }

  Future<void> _submitSelectedDrugs() async {
    try {
      final success =
      await _clinicRepository.consumeSelectedDrugs(_selectedDrugIds);
      if (success) {
        final updatedDrugs = await _loadDrugs();
        setState(() {
          _drugsFuture = Future.value(updatedDrugs);
          _selectedDrugIds.clear();
        });
      }
    } catch (e) {
      print('Error during drug submission: $e');
    }
  }

  Future<void> _rollbackDrugs() async {
    if (_rollbackDate != null) {
      final success =
      await _clinicRepository.rollbackConsumedDrugs(_rollbackDate!);
      if (success) {
        print('Drugs successfully rolled back.');
        setState(() {
          _drugsFuture = _loadDrugs();
        });
      } else {
        print('Failed to rollback drugs.');
      }
    } else {
      print('No rollback date set.');
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'DailyDrugWidget',
      screenClass: 'DailyDrugWidget',
    );

    return FutureBuilder<List<Drug>>(
      future: _drugsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load drugs'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No drugs available'));
        } else {
          final drugs = snapshot.data!;
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xff323232),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DateTitleWidget(),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/develop/reset.svg',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () async {
                        await _rollbackDrugs();
                      },
                    )
                  ],
                ),
                SizedBox(height: 16),
                DrugListWidget(
                  drugs: drugs,
                  selectedDrugIds: _selectedDrugIds,
                  onDrugSelection: _toggleDrugSelection,
                ),
                SizedBox(height: 16),
                Center(
                  child: SubmitButtonWidget(
                    isEnabled: _selectedDrugIds.isNotEmpty,
                    onSubmit: _submitSelectedDrugs,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class DateTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('M월 d일 복용 여부').format(DateTime.now().toLocal()),
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}

class DrugListWidget extends StatelessWidget {
  final List<Drug> drugs;
  final List<int> selectedDrugIds;
  final Function(int) onDrugSelection;

  DrugListWidget({
    required this.drugs,
    required this.selectedDrugIds,
    required this.onDrugSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: drugs.map((drug) {
        final isSelected = selectedDrugIds.contains(drug.drugId);
        final initialNumber = drug.initialNumber;
        final displayNumber = isSelected ? drug.number - 1 : drug.number;

        final displayNumberColor =
        !drug.allow ? Color(0xff848481) : Colors.white;
        final initialNumberColor = Color(0xff848481);

        final drugNameColor = !drug.allow ? Color(0xff848481) : Colors.white;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: drug.allow
                      ? () {
                    onDrugSelection(drug.drugId);
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color:
                      isSelected ? Color(0xffD0EE17) : Colors.transparent,
                      width: 1.0,
                    ),
                    backgroundColor: isSelected
                        ? Color(0xffD0EE17).withOpacity(0.1)
                        : Color(0xff1C1B1B),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          '${drug.myDrugArchive.drugName} ${drug.myDrugArchive.capacity}mg',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            color: drugNameColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            // displayNumber
                            Text(
                              '$displayNumber',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                color: displayNumberColor,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '/$initialNumber',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                color: initialNumberColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class SubmitButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onSubmit;

  SubmitButtonWidget({
    required this.isEnabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCompleteButton(
      onPressed: isEnabled ? onSubmit : null,
      isEnabled: isEnabled,
      text: "선택하기",
    );
  }
}
