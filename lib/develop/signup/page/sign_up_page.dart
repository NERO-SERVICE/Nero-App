import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/layout/common_layout.dart';
import 'package:nero_app/develop/signup/controller/sign_up_controller.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FocusNode _focusNodeNickName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeBirth = FocusNode();
  final SignUpController controller = Get.put(SignUpController());

  final List<String> sexOptions = ['여성', '남성', '기타'];

  @override
  void initState() {
    super.initState();

    _focusNodeNickName.addListener(() {
      setState(() {});
    });
    _focusNodeEmail.addListener(() {
      setState(() {});
    });
    _focusNodeBirth.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNodeNickName.dispose();
    _focusNodeEmail.dispose();
    _focusNodeBirth.dispose();
    super.dispose();
  }

  Widget _signUpNickName() {
    return Focus(
      focusNode: _focusNodeNickName,
      child: TextField(
        onChanged: (value) => controller.nickname.value = value,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: '닉네임을 입력해주세요',
          hintStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff959595),
          ),
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
          fillColor: _focusNodeNickName.hasFocus
              ? const Color(0xffD0EE17).withOpacity(0.1)
              : const Color(0xff3B3B3B),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _signUpEmail() {
    return Focus(
      focusNode: _focusNodeEmail,
      child: TextField(
        onChanged: (value) => controller.email.value = value,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: '이메일을 입력해주세요',
          hintStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff959595),
          ),
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
          fillColor: _focusNodeEmail.hasFocus
              ? const Color(0xffD0EE17).withOpacity(0.1)
              : const Color(0xff3B3B3B),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _signUpBirth() {
    return Focus(
      focusNode: _focusNodeBirth,
      child: TextField(
        onChanged: (value) {
          if (value.length == 6) {
            controller.birth.value = value;
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: '생년월일을 입력해주세요 (ex. 950101)',
          hintStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff959595),
          ),
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
          fillColor: _focusNodeBirth.hasFocus
              ? const Color(0xffD0EE17).withOpacity(0.1)
              : const Color(0xff3B3B3B),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _sexDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.selectedSex.value.isNotEmpty ? controller.selectedSex.value : null,
      menuMaxHeight: 200,
      dropdownColor: const Color(0xff3C3C3C),
      hint: const Center(
        child: Text(
          '성별을 선택해주세요',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff959595),
          ),
        ),
      ),
      decoration: InputDecoration(
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
        fillColor: const Color(0xff3B3B3B),
        contentPadding: const EdgeInsets.all(20),
      ),
      items: sexOptions.map((sex) {
        return DropdownMenuItem<String>(
          value: sex,
          child: Center(
            child: Text(
              sex,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xffFFFFFF),
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          print('선택된 성별: $value');
          controller.selectedSex.value = value;
        }
      },
      style: TextStyle(
        color: controller.selectedSex.value.isNotEmpty ? const Color(0xffFFFFFF) : const Color(0xff959595),
      ),
    );
  }

  Widget _nextButton() {
    return ElevatedButton(
      onPressed: () {
        print("Nickname: ${controller.nickname.value}");
        print("Email: ${controller.email.value}");
        print("Birth: ${controller.birth.value}");
        print("Selected Sex: ${controller.selectedSex.value}");

        Get.offNamed('/memories');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff3C3C3C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: const Text(
          '다음에',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            color: Color(0xff959595),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          DateTime? parsedBirth = _parseBirth(controller.birth.value);
          if (parsedBirth == null) {
            print('유효하지 않은 생년월일입니다.');
            return;
          }

          final currentUser = NeroUser(
            userId: 1,
            kakaoId: 1,
            createdAt: DateTime.now(),
            nickname: controller.nickname.value,
            email: controller.email.value,
            birth: parsedBirth,
            sex: controller.selectedSex.value,
          );
          await controller.updateUserInfo(currentUser);

          Get.offNamed('/memories');
        } catch (e) {
          print('유저 정보 업데이트 중 오류 발생: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffD0EE17).withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: const Text(
          '등록하기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            color: Color(0xffFFFFFF),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  DateTime? _parseBirth(String birthInput) {
    if (birthInput.length == 6) {
      try {
        String prefix = int.parse(birthInput.substring(0, 2)) > 21 ? '19' : '20';
        String formattedBirth = '$prefix${birthInput.substring(0, 2)}-${birthInput.substring(2, 4)}-${birthInput.substring(4, 6)}';
        return DateFormat('yyyy-MM-dd').parse(formattedBirth);
      } catch (e) {
        print('생년월일 변환 중 오류 발생: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          '프로필 설정',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xffFFFFFF),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/develop/3d-bell-icon.png'),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _signUpNickName(),
                  const SizedBox(height: 16),
                  _signUpEmail(),
                  const SizedBox(height: 16),
                  _signUpBirth(),
                  const SizedBox(height: 16),
                  _sexDropdown(),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _nextButton(),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _registerButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
