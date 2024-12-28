class HealthUserInfo {
  final int? id;
  final int fitnessLevel;
  final int age;
  final double height;
  final double weight;
  final double waistCircumference;
  final String gender;

  HealthUserInfo({
    this.id,
    required this.fitnessLevel,
    required this.age,
    required this.height,
    required this.weight,
    required this.waistCircumference,
    required this.gender,
  });

  factory HealthUserInfo.fromJson(Map<String, dynamic> json) {
    return HealthUserInfo(
      id: json['id'],
      fitnessLevel: json['fitness_level'],
      age: json['age'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      waistCircumference: (json['waist_circumference'] as num).toDouble(),
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fitness_level': fitnessLevel,
      'age': age,
      'height': height,
      'weight': weight,
      'waist_circumference': waistCircumference,
      'gender': gender,
    };
  }
}
