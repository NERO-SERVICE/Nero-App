enum MonthImage {
  january('assets/develop/month/month-1.png'),
  february('assets/develop/month/month-2.png'),
  march('assets/develop/month/month-3.png'),
  april('assets/develop/month/month-4.png'),
  may('assets/develop/month/month-5.png'),
  june('assets/develop/month/month-6.png'),
  july('assets/develop/month/month-7.png'),
  august('assets/develop/month/month-8.png'),
  september('assets/develop/month/month-9.png'),
  october('assets/develop/month/month-10.png'),
  november('assets/develop/month/month-11.png'),
  december('assets/develop/month/month-12.png');

  final String assetPath;
  const MonthImage(this.assetPath);

  static MonthImage fromDateTime(DateTime date) {
    switch (date.month) {
      case 1:
        return MonthImage.january;
      case 2:
        return MonthImage.february;
      case 3:
        return MonthImage.march;
      case 4:
        return MonthImage.april;
      case 5:
        return MonthImage.may;
      case 6:
        return MonthImage.june;
      case 7:
        return MonthImage.july;
      case 8:
        return MonthImage.august;
      case 9:
        return MonthImage.september;
      case 10:
        return MonthImage.october;
      case 11:
        return MonthImage.november;
      case 12:
        return MonthImage.december;
      default:
        return MonthImage.january; // Default case
    }
  }
}
