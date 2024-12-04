import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/model/health_user_info.dart';
import 'package:nero_app/develop/health/page/health_video_page.dart';

class HealthWritePage extends StatefulWidget {
  @override
  _HealthWritePageState createState() => _HealthWritePageState();
}

class _HealthWritePageState extends State<HealthWritePage> {
  final HealthController _healthController = Get.put(HealthController());

  final _formKey = GlobalKey<FormState>();

  int _fitnessLevel = 1;
  int _age = 20;
  double _height = 170.0;
  double _weight = 60.0;
  double _waistCircumference = 80.0;
  String _gender = 'M';
  String _coawFlagNm = '참가증';

  @override
  void initState() {
    super.initState();
    _loadHealthUserInfo();
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
        _coawFlagNm = info.coawFlagNm;
      });
    }
  }

  void _saveHealthUserInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      HealthUserInfo info = HealthUserInfo(
        fitnessLevel: _fitnessLevel,
        age: _age,
        height: _height,
        weight: _weight,
        waistCircumference: _waistCircumference,
        gender: _gender,
        coawFlagNm: _coawFlagNm,
      );

      await _healthController.createOrUpdateHealthUserInfo(info);

      if (_healthController.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('건강 정보가 저장되었습니다.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthVideoPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('건강 정보를 저장하는 중 오류 발생: ${_healthController.error}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('건강 정보 입력'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _fitnessLevel,
                decoration: InputDecoration(labelText: '체력 등급'),
                items: [1, 2, 3, 4].map((level) {
                  String label;
                  switch (level) {
                    case 1:
                      label = '1등급';
                      break;
                    case 2:
                      label = '2등급';
                      break;
                    case 3:
                      label = '3등급';
                      break;
                    case 4:
                      label = '참가증';
                      break;
                    default:
                      label = '$level 등급';
                  }
                  return DropdownMenuItem(
                    value: level,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _fitnessLevel = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '체력 등급을 선택해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: '$_age',
                decoration: InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
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
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: '$_height',
                decoration: InputDecoration(labelText: '키 (cm)'),
                keyboardType: TextInputType.number,
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
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: '$_weight',
                decoration: InputDecoration(labelText: '몸무게 (kg)'),
                keyboardType: TextInputType.number,
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
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: '$_waistCircumference',
                decoration: InputDecoration(labelText: '허리둘레 (cm)'),
                keyboardType: TextInputType.number,
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
              SizedBox(height: 16.0),
              // 성별 선택
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: '성별'),
                items: [
                  DropdownMenuItem(
                    value: 'M',
                    child: Text('남성'),
                  ),
                  DropdownMenuItem(
                    value: 'F',
                    child: Text('여성'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '성별을 선택해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _coawFlagNm,
                decoration: InputDecoration(labelText: 'COAW 등급'),
                items: ['1등급', '2등급', '3등급', '참가증'].map((flag) {
                  return DropdownMenuItem(
                    value: flag,
                    child: Text(flag),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _coawFlagNm = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'COAW 등급을 선택해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveHealthUserInfo,
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
