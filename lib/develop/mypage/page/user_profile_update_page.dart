import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/mypage/controller/user_profile_update_controller.dart';
import 'package:flutter/services.dart';
import 'package:nero_app/develop/common/layout/common_layout.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileUpdatePage extends StatefulWidget {
  const UserProfileUpdatePage({super.key});

  @override
  State<UserProfileUpdatePage> createState() => _UserProfileUpdatePageState();
}

class _UserProfileUpdatePageState extends State<UserProfileUpdatePage> {
  final FocusNode _focusNodeNickName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeBirth = FocusNode();
  final UserProfileUpdateController controller =
  Get.put(UserProfileUpdateController());

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

  Widget _editIcon() {
    return Positioned(
      bottom: 0,
      right: 4,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffD0EE17),
          shape: BoxShape.circle,
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.edit,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _profileImage() {
    return Obx(() {
      if (controller.selectedImage.value != null) {
        // Display the selected local image
        return GestureDetector(
          onTap: controller.pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.grey[800],
                backgroundImage: FileImage(controller.selectedImage.value!),
              ),
              _editIcon(),
            ],
          ),
        );
      } else if (controller.profileImageUrl.value.isNotEmpty) {
        return GestureDetector(
          onTap: controller.pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.grey[800],
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: controller.profileImageUrl.value,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey[800],
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              _editIcon(),
            ],
          ),
        );
      } else {
        return GestureDetector(
          onTap: controller.pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 75,
                backgroundColor: Colors.grey,
              ),
              _editIcon(),
            ],
          ),
        );
      }
    });
  }

  Widget _profileNicknameField() {
    return Focus(
      focusNode: _focusNodeNickName,
      child: TextField(
        controller: controller.nicknameController,
        cursorColor: Color(0xffD9D9D9),
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

  Widget _profileEmailField() {
    return Focus(
      focusNode: _focusNodeEmail,
      child: TextField(
        controller: controller.emailController,
        cursorColor: Color(0xffD9D9D9),
        keyboardType: TextInputType.emailAddress,
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

  Widget _profileBirthField() {
    return Focus(
      focusNode: _focusNodeBirth,
      child: TextField(
        controller: controller.birthController,
        cursorColor: Color(0xffD9D9D9),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
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
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: controller.selectedSex.value.isNotEmpty ? controller.selectedSex.value : null,
        menuMaxHeight: 200,
        dropdownColor: const Color(0xff3C3C3C),
        items: sexOptions.map((sex) {
          return DropdownMenuItem<String>(
            value: sex,
            child: Text(
              sex,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xffFFFFFF),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) controller.selectedSex.value = value;
        },
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
        style: TextStyle(
          color: controller.selectedSex.value.isNotEmpty
              ? const Color(0xffFFFFFF)
              : const Color(0xff959595),
        ),
        hint: Text(
          '성별을 선택해주세요',
          style: TextStyle(
            color: const Color(0xff959595),
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      );
    });
  }

  Widget _updateButton() {
    return ElevatedButton(
      onPressed: controller.updateUserInfo,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffD0EE17).withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '저장하기',
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CommonLayout(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            '프로필 수정',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xffFFFFFF),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Center(
                  child: _profileImage(),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      _profileNicknameField(),
                      const SizedBox(height: 16),
                      _sexDropdown(),
                      const SizedBox(height: 16),
                      _profileEmailField(),
                      const SizedBox(height: 16),
                      _profileBirthField(),
                      const SizedBox(height: 32),
                      _updateButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
