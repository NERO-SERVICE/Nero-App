import 'dart:ui';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/model/health_user_info.dart';
import 'package:nero_app/develop/health/page/health_page.dart';

class HealthWritePage extends StatefulWidget {
  @override
  _HealthWritePageState createState() => _HealthWritePageState();
}

class _HealthWritePageState extends State<HealthWritePage> {
  final HealthController _healthController = Get.put(HealthController());

  final _formKey = GlobalKey<FormState>();

  int _fitnessLevel = 1;
  String _gender = 'M';
  int? _age;
  double? _height;
  double? _weight;
  double? _waistCircumference;

  final FocusNode _focusNodeAge = FocusNode();
  final FocusNode _focusNodeHeight = FocusNode();
  final FocusNode _focusNodeWeight = FocusNode();
  final FocusNode _focusNodeWaist = FocusNode();

  bool _isLoading = false;
  bool _isFetchingSteps = false;

  @override
  void initState() {
    super.initState();
    _loadHealthUserInfo();

    _focusNodeAge.addListener(() {
      setState(() {});
    });
    _focusNodeHeight.addListener(() {
      setState(() {});
    });
    _focusNodeWeight.addListener(() {
      setState(() {});
    });
    _focusNodeWaist.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNodeAge.dispose();
    _focusNodeHeight.dispose();
    _focusNodeWeight.dispose();
    _focusNodeWaist.dispose();
    super.dispose();
  }

  Future<void> _loadHealthUserInfo() async {
    await _healthController.fetchHealthUserInfo();
    final info = _healthController.healthUserInfo;
    if (info != null) {
      setState(() {
        _fitnessLevel = info.fitnessLevel;
        _age = info.age;
        _height = info.height;
        _weight = info.weight;
        _waistCircumference = info.waistCircumference;
        _gender = info.gender;
      });
    }
  }

  void _saveHealthUserInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true; // 로딩 시작
      });

      HealthUserInfo info = HealthUserInfo(
        fitnessLevel: _fitnessLevel,
        age: _age!,
        height: _height!,
        weight: _weight!,
        waistCircumference: _waistCircumference!,
        gender: _gender,
      );

      try {
        await _healthController.createOrUpdateHealthUserInfo(info);

        // 3초간 로딩 상태 유지
        await Future.delayed(Duration(seconds: 3));

        setState(() {
          _isLoading = false; // 로딩 종료
        });

        if (_healthController.error == null) {
          CustomSnackbar.show(
              context: context, message: '건강 정보가 저장되었습니다.', isSuccess: true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HealthPage()),
          );
        } else {
          CustomSnackbar.show(
              context: context, message: '건강 정보가 저장을 실패했습니다', isSuccess: false);
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // 로딩 종료
        });

        CustomSnackbar.show(
            context: context, message: '건강 정보가 저장을 실패했습니다', isSuccess: false);
      }
    }
  }

  void _fetchSteps() async {
    setState(() {
      _isFetchingSteps = true;
    });

    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 30));

    try {
      await _healthController.collectAndSaveSteps(
        startDate: startDate,
        endDate: endDate,
      );

      CustomSnackbar.show(
        context: context,
        message: '걸음 수 데이터를 성공적으로 가져왔습니다',
        isSuccess: true,
      );
    } catch (e) {
      CustomSnackbar.show(
        context: context,
        message: '걸음 수 데이터를 가져오는 중 오류가 발생했습니다.',
        isSuccess: false,
      );
    } finally {
      setState(() {
        _isFetchingSteps = false;
      });
    }
  }

  Widget _buildStyledTextField({
    required String labelText,
    required String initialValue,
    required FocusNode focusNode,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? hintText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 라벨 텍스트
        SizedBox(
          width: 80,
          child: Text(
            labelText,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff959595),
            ),
          ),
        ),
        SizedBox(width: 10),
        // 입력 필드
        Expanded(
          child: Focus(
            focusNode: focusNode,
            child: TextFormField(
              initialValue: initialValue,
              cursorColor: Color(0xffD9D9D9),
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              validator: validator,
              onSaved: onSaved,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xffFFFFFF),
                decoration: TextDecoration.none,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.hintTextColor,
                ),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xffD0EE17),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: focusNode.hasFocus
                    ? const Color(0xffD0EE17).withOpacity(0.1)
                    : const Color(0xff3B3B3B),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledButtonField({
    required String labelText,
    required VoidCallback onPressed,
    required bool isLoading,
    required String buttonText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 라벨 텍스트
        SizedBox(
          width: 80,
          child: Text(
            labelText,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.titleColor,
            ),
          ),
        ),
        SizedBox(width: 10),
        // 버튼 부분
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xff4285F4).withOpacity(0.2),
              border: Border.all(
                color: Color(0xff4285F4),
                width: 1,
              ),
            ),
            child: TextButton(
              onPressed: isLoading ? null : onPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor:
                    isLoading ? Color(0xff4285F4).withOpacity(0.2) : Colors.transparent,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xffD0EE17)),
                        strokeWidth: 1,
                      ),
                    )
                  : Text(
                      buttonText,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.titleColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fitnessLevelButtonBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '체력 등급',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff959595),
          ),
        ),
        SizedBox(height: 8.0),
        AnimatedButtonBar(
          backgroundColor: Color(0xff3C3C3C),
          foregroundColor: Color(0xffD0EE17),
          radius: 16.0,
          innerVerticalPadding: 13,
          children: [
            ButtonBarEntry(
              onTap: () {
                setState(() {
                  _fitnessLevel = 1;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                // Reduced horizontal padding
                child: Text(
                  '1등급',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0Xff959595),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            ButtonBarEntry(
              onTap: () {
                setState(() {
                  _fitnessLevel = 2;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  '2등급',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0Xff959595),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            ButtonBarEntry(
              onTap: () {
                setState(() {
                  _fitnessLevel = 3;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  '3등급',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0Xff959595),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            ButtonBarEntry(
              onTap: () {
                setState(() {
                  _fitnessLevel = 4;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  '참가증',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0Xff959595),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _genderButtonBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '성별',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff959595),
          ),
        ),
        SizedBox(height: 8.0),
        AnimatedButtonBar(
          backgroundColor: Color(0xff3C3C3C),
          foregroundColor: Color(0xffD0EE17),
          radius: 16.0,
          innerVerticalPadding: 13,
          children: [
            ButtonBarEntry(
              onTap: () {
                setState(() {
                  _gender = 'M';
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                // Reduced horizontal padding
                child: Text(
                  '남성',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0Xff959595),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            ButtonBarEntry(
              onTap: () {
                setState(() {
                  _gender = 'F';
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  '여성',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0Xff959595),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomDetailAppBar(
            title: '건강 정보 입력',
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque, // 모든 터치 이벤트를 감지
            onTap: () {
              FocusScope.of(context).unfocus(); // 포커스 해제하여 키보드 숨기기
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/develop/exercise.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 30),
            
                    // 체력 등급
                    _fitnessLevelButtonBar(),
                    SizedBox(height: 8),
            
                    // 성별
                    _genderButtonBar(),
                    SizedBox(height: 32),
            
                    // 나이
                    _buildStyledTextField(
                      labelText: '나이',
                      initialValue: _age != null ? _age.toString() : '',
                      focusNode: _focusNodeAge,
                      keyboardType: TextInputType.number,
                      hintText: '숫자로 입력하세요',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '나이를 입력해주세요.';
                        }
                        if (int.tryParse(value) == null) {
                          return '유효한 나이를 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _age = int.parse(value!);
                      },
                    ),
                    SizedBox(height: 30),
            
                    // 키
                    _buildStyledTextField(
                      labelText: '키 (cm)',
                      initialValue: _height != null ? _height.toString() : '',
                      focusNode: _focusNodeHeight,
                      keyboardType: TextInputType.number,
                      hintText: '숫자로 입력하세요',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '키를 입력해주세요.';
                        }
                        if (double.tryParse(value) == null) {
                          return '유효한 키를 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _height = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 30),
            
                    // 몸무게
                    _buildStyledTextField(
                      labelText: '몸무게 (kg)',
                      initialValue: _weight != null ? _weight.toString() : '',
                      focusNode: _focusNodeWeight,
                      keyboardType: TextInputType.number,
                      hintText: '숫자로 입력하세요',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '몸무게를 입력해주세요.';
                        }
                        if (double.tryParse(value) == null) {
                          return '유효한 몸무게를 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _weight = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 30),
            
                    // 허리둘레
                    _buildStyledTextField(
                      labelText: '허리둘레 (cm)',
                      initialValue: _waistCircumference != null ? _waistCircumference.toString() : '',
                      focusNode: _focusNodeWaist,
                      keyboardType: TextInputType.number,
                      hintText: '숫자로 입력하세요',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '허리둘레를 입력해주세요.';
                        }
                        if (double.tryParse(value) == null) {
                          return '유효한 허리둘레를 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _waistCircumference = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 30),
            
                    _buildStyledButtonField(
                      labelText: '걸음 수',
                      onPressed: _fetchSteps,
                      isLoading: _isFetchingSteps,
                      buttonText: '걸음 수 가져오기',
                    ),
                    SizedBox(height: 30),
            
                    // 저장
                    ElevatedButton(
                      onPressed: _saveHealthUserInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3C3C3C),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '저장',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '분석중...',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Color(0xffFFFFFF),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'AI알고리즘을 통해\n입력한 정보를 분석하고 있어요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xffFFFFFF),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
