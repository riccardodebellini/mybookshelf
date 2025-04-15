extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  DateTime toDateTime() {
    final int year = int.tryParse(substring(0, 4)) ?? 0001;
    final int month = int.tryParse(substring(5, 7)) ?? 01;
    final int day = int.tryParse(substring(8, 10)) ?? 01;
    return DateTime(year, month, day);
  }

  String toShortString() {
    final year = (int.tryParse(substring(0, 2)) ?? 01).toChars(2);
    final month = (int.tryParse(substring(3, 5)) ?? 01).toChars(2);
    final day = (int.tryParse(substring(6, 10)) ?? 0001).toChars(4);

    return "$year-$month-$day";
  }
}

extension DateTimeExtensions on DateTime {
  String toReadable() {
    return "$day/$month/$year";
  }

  String toShortString() {
    return "$year-$month-$day";
  }
}

extension IntExtensions on int {
  String toChars(int n) {
    if (this < (10 ^ (n - 1)) && this > -1) {
      var string = toString();
      while (string.length != n) {
        string = "0$string";
      }
      return string;
    } else {
      return toString();
    }
  }
}
