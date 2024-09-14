import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/signup/controller/sign_up_controller.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';

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
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: '닉네임을 입력해주세요',
          hintStyle: TextStyle(
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
            borderSide: BorderSide(
              color: Color(0xffD0EE17),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: _focusNodeNickName.hasFocus ? Color(0xffD0EE17).withOpacity(0.1) : Color(0xff3B3B3B),
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
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: '이메일을 입력해주세요',
          hintStyle: TextStyle(
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
            borderSide: BorderSide(
              color: Color(0xffD0EE17),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: _focusNodeEmail.hasFocus ? Color(0xffD0EE17).withOpacity(0.1) : Color(0xff3B3B3B),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _signUpBirth() {
    return Focus(
      focusNode: _focusNodeBirth,
      child: TextField(
        onChanged: (value) => controller.birth.value = value,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
        decoration: InputDecoration(
          hintText: '생년월일을 입력해주세요 (ex. 950101)',
          hintStyle: TextStyle(
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
            borderSide: BorderSide(
              color: Color(0xffD0EE17),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: _focusNodeBirth.hasFocus ? Color(0xffD0EE17).withOpacity(0.1) : Color(0xff3B3B3B),
          contentPadding: const EdgeInsets.all(20),
        ),
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
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff3C3C3C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
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
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffD0EE17).withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
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
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
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
            SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/develop/3d-bell-icon.png'),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _signUpNickName(),
                  SizedBox(height: 16),
                  _signUpEmail(),
                  SizedBox(height: 16),
                  _signUpBirth(),
                  SizedBox(height: 16),
                  SignupSexDropdown(),
                ],
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _nextButton(),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _registerButton(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignupSexDropdown extends StatelessWidget {
  final SignUpController controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      menuMaxHeight: 200,
      dropdownColor: Color(0xff3C3C3C),
      hint: Center(
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
          borderSide: BorderSide(
            color: Color(0xffD0EE17),
            width: 1,
          ),
        ),
        filled: true,
        fillColor: Color(0xff3B3B3B),
        contentPadding: const EdgeInsets.all(20),
      ),
      items: controller.sexOptions.map((sex) {
        return DropdownMenuItem<String>(
          value: sex,
          child: Center(
            child: Text(
              sex,
              style: TextStyle(
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
        controller.selectedSex.value = value as String;
      },
      style: TextStyle(
        color: controller.selectedSex.value.isNotEmpty
            ? Color(0xffFFFFFF)
            : Color(0xff959595),
      ),
    );
  }
}
