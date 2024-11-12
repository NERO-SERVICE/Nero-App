import 'package:flutter/material.dart';

class CommunitySearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onBack;

  CommunitySearchAppBar({
    required this.searchController,
    required this.onSearch,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: searchController,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Color(0xffd9d9d9)),
        ),
        style: TextStyle(color: Colors.white),
        cursorColor: Color(0xffd9d9d9),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: onSearch,
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.white),
        onPressed: onBack,  // 뒤로 가기 버튼에 onBack 콜백 할당
      ),
      backgroundColor: Color(0xff202020),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
