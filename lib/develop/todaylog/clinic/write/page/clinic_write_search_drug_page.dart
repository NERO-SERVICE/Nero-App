import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/todaylog/clinic/model/drug_archive.dart';
import 'package:nero_app/develop/todaylog/clinic/repository/clinic_repository.dart';

class ClinicWriteSearchDrugPage extends StatefulWidget {
  @override
  _ClinicWriteSearchDrugPageState createState() =>
      _ClinicWriteSearchDrugPageState();
}

class _ClinicWriteSearchDrugPageState extends State<ClinicWriteSearchDrugPage> {
  final TextEditingController _searchController = TextEditingController();
  final ClinicRepository _clinicRepository = ClinicRepository();
  List<DrugArchive> _searchResults = [];
  bool _isLoading = false;

  void _searchDrugs(String query) async {
    if (query.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final results = await _clinicRepository.searchDrugArchives(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
      if (results.isEmpty) {}
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectDrug(DrugArchive drugArchive) async {
    Get.back(result: drugArchive);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: '검색어 입력',
          hintStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.hintTextColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _searchDrugs(_searchController.text);
            },
          ),
          filled: true,
          fillColor: Color(0xff3C3C3C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xffD0EE17)),
          ),
        ),
        onSubmitted: _searchDrugs,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return Center(child: CustomLoadingIndicator());
    }

    if (_searchResults.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            '검색 결과가 없습니다.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final drug = _searchResults[index];
          return ListTile(
            leading: SvgPicture.asset(
              'assets/develop/arrow-left.svg',
              width: 24,
              height: 24,
            ),
            title: Text(
              '${drug.drugName} (${drug.capacity}mg)',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.primaryTextColor,
              ),
            ),
            onTap: () {
              _selectDrug(drug);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomDetailAppBar(title: '처방약 검색'),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSearchResults(),
        ],
      ),
    );
  }
}
