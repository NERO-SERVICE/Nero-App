enum ProductCategoryType {
  none('카테고리 선택', ''),
  digital('디지털 기기', 'PT1'),
  houstholdAppliances('생활 가전', 'PT2'),
  furniture('가구/인테리어', 'PT3'),
  life('생활/주방', 'PT4'),
  children('유아동', 'PT5'),
  childrenBook('유아 도서', 'PT6'),
  womenClothing('여성 의류', 'PT7'),
  womanAccessories('여성 잡화', 'PT8'),
  menFasion('남성 패션/잡화', 'PT9'),
  beauty('뷰티/미용', 'PT10'),
  sports('스포츠/레저', 'PT11'),
  hobby('취미/게임/음반', 'PT12'),
  books('도서', 'PT13'),
  ticket('티켓/교환권', 'PT14'),
  processedFood('가공 식품', 'PT15'),
  petSupplies('반려동물 용품', 'PT16'),
  plant('식물', 'PT17'),
  etc('기타 중고 물품', 'PT18');

  const ProductCategoryType(this.name, this.code);
  final String name;
  final String code;

  static ProductCategoryType? findByCode(String code) {
    var result = ProductCategoryType.values.where((element) => element.code ==code);
    if (result.isEmpty) return null;
    return result.first;
  }

}