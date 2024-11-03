import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/calandar_widget.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import '../../common/components/custom_detail_app_bar.dart';
import '../../common/layout/common_layout.dart';
import '../controller/mypage_controller.dart';
import '../model/menstruation_cycle.dart';

class MenstruationListPage extends StatefulWidget {
  @override
  _MenstruationListPageState createState() => _MenstruationListPageState();
}

class _MenstruationListPageState extends State<MenstruationListPage> {
  final MypageController _mypageController = Get.find<MypageController>();
  final Map<int, bool> _selectedMap = {}; // 선택된 아이템의 인덱스를 저장
  final Set<int> _expandedIndices = {}; // 노트를 표시할 아이템의 인덱스

  @override
  void initState() {
    super.initState();
    _mypageController.fetchMenstruationCycles(DateTime.now().year);
  }

  Future<bool> _showConfirmationDialog(
      String content, String confirm, Color dialogColor) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xffD8D8D8).withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Center(
                            child: Text(
                              "취소",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: dialogColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Center(
                            child: Text(
                              confirm,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cycleListItem(
      MenstruationCycle cycle, bool isSelected, int index) {
    Color containerColor = Color(0xffD8D8D8).withOpacity(0.3);

    BorderSide borderSide = BorderSide(
        color: isSelected ? Color(0xffFFFFFF) : Colors.transparent, width: 1);

    bool isExpanded = _expandedIndices.contains(index);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMap[index] = !isSelected;
            if (isExpanded) {
              _expandedIndices.remove(index);
            } else {
              _expandedIndices.add(index);
            }
          });
        },
        onLongPress: () {
          setState(() {
            _selectedMap[index] = !isSelected;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: containerColor,
            border:
            Border.all(color: borderSide.color, width: borderSide.width),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedMap[index] == true
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedMap[index] == true
                          ? Color(0xffFFADC6)
                          : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${DateFormat('yy.MM.dd').format(cycle.startDate)} - ${DateFormat('yy.MM.dd').format(cycle.endDate)}',
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _buildExpandedContent(cycle, isExpanded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(MenstruationCycle cycle, bool isExpanded) {
    if (!isExpanded) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffD8D8D8).withOpacity(0.2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cycle.notes != null && cycle.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Text(
                cycle.notes!,
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 14,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _showEditCycleDialog(cycle);
                  },
                  child: Text(
                    '수정하기',
                    style: TextStyle(
                      color: Color(0xffC5C5C5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _confirmDeleteCycle(cycle);
                  },
                  child: Text(
                    '삭제하기',
                    style: TextStyle(
                      color: Color(0xffFF5A5A).withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _confirmDeleteCycle(MenstruationCycle cycle) async {
    bool confirmed = await _showConfirmationDialog(
      "생리 주기를 삭제하시겠습니까?",
      "삭제하기",
      Color(0xffFF5A5A).withOpacity(0.4),
    );

    if (confirmed) {
      await _mypageController.deleteMenstruationCycle(cycle.id!);
      _mypageController.fetchMenstruationCycles(DateTime.now().year);
      setState(() {
        _expandedIndices.clear();
      });
    }
  }

  void _showAddCycleDialog() {
    _showCycleInputDialog();
  }

  void _showEditCycleDialog(MenstruationCycle cycle) {
    _showCycleInputDialog(cycle: cycle);
  }

  void _showCycleInputDialog({MenstruationCycle? cycle}) {
    Rx<DateTime> startDate = (cycle?.startDate ?? DateTime.now()).obs;
    Rx<DateTime> endDate = (cycle?.endDate ?? DateTime.now()).obs;
    TextEditingController notesController =
    TextEditingController(text: cycle?.notes ?? '');

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          cycle == null ? '생리 주기 추가' : '생리 주기 수정',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildDateSelector('시작일', startDate),
                        SizedBox(height: 20),
                        _buildDateSelector('종료일', endDate),
                        SizedBox(height: 20),
                        _buildNotesField(notesController),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (endDate.value.isBefore(startDate.value)) {
                              CustomSnackbar.show(
                                context: Get.context!,
                                message: '종료일은 시작일보다 빠를 수 없습니다.',
                                isSuccess: false,
                              );
                              return;
                            }

                            MenstruationCycle newCycle = MenstruationCycle(
                              id: cycle?.id,
                              owner: 1,
                              startDate: startDate.value,
                              endDate: endDate.value,
                              notes: notesController.text,
                            );

                            if (cycle == null) {
                              await _mypageController
                                  .createMenstruationCycle(newCycle);
                            } else {
                              await _mypageController
                                  .updateMenstruationCycle(newCycle);
                            }
                            _mypageController
                                .fetchMenstruationCycles(DateTime.now().year);
                            Navigator.of(context).pop();
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
                            cycle == null ? '추가하기' : '수정하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xffFFADC6),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
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

  Widget _buildDateSelector(String label, Rx<DateTime> date) {
    final RxBool isSelected = false.obs;

    return Obx(() {
      return GestureDetector(
        onTap: () async {
          isSelected.value = true;
          await _selectDate(context, date, {}); // 빈 Set 전달
          isSelected.value = false;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected.value ? Color(0xffFFADC6) : Color(0xffD9D9D9),
            ),
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

  Widget _buildNotesField(TextEditingController controller) {
    return TextField(
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
        hintText: '메모를 입력해주세요',
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
          borderSide: BorderSide(color: Color(0xffFFADC6), width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 13),
      ),
      maxLines: null,
    );
  }

  Future<void> _selectDate(BuildContext context, Rx<DateTime> date,
      Set<DateTime> recordedDates) async {
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
              child: CalendarWidget(
                initialSelectedDate: date.value,
                initialFocusedDate: date.value,
                markedDates: recordedDates,
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

  Widget _buildCustomActionButton(
      IconData iconData, String tooltip, VoidCallback? onPressed,
      {required Color backgroundColor, required double size}) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      shape: CircleBorder(),
      child: Icon(
        iconData,
        size: size,
        color: Colors.white,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: CustomDetailAppBar(title: '생리 주기 관리'),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 26)),
              SliverToBoxAdapter(
                child: Center(
                  child: Image.asset(
                    'assets/develop/tutorial-7.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 26)),
              Obx(() {
                if (_mypageController.menstruationCycles.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        '등록된 생리 주기가 없습니다.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                    ),
                  );
                }
                final cycles = _mypageController.menstruationCycles;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final cycle = cycles[index];
                      bool isSelected = _selectedMap[index] ?? false;
                      return _cycleListItem(cycle, isSelected, index);
                    },
                    childCount: cycles.length,
                  ),
                );
              }),
              SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildCustomActionButton(
                  Icons.add,
                  "생리 주기 추가",
                  _showAddCycleDialog,
                  backgroundColor: Color(0xffFFADC6).withOpacity(0.5),
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
