import 'package:intl/intl.dart';

class CommonUtils {
  String formatStringToDDMMMYYYYHHMMSSA(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDateTimeString = DateFormat('dd MMMM, yyyy, hh:mm:ss a').format(dateTime);
    return formattedDateTimeString;
  }

  String formatStringToDDMMYYYYHHMMA(String date) {
    DateTime dateTime = DateTime.parse(date);

    String formattedDateTimeString = DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
    return formattedDateTimeString;
  }

  int getDifferenceBetweenGivenTimeFromNow(String time) {
    var timeFormat = DateFormat('hh:mm a');
    var inputDate = timeFormat.parse(time);

    var tempTime = timeFormat.format(DateTime.now());
    var formattedTime = timeFormat.parse(tempTime);

    int difference = inputDate.difference(formattedTime).inMinutes;
    return difference;
  }

  String formatStringToHHMMA(String time) {
    final parsedTime = DateFormat("HH:mm:ss").parse(time);
    final formattedTime = DateFormat("hh:mm a").format(parsedTime);
    return formattedTime;
  }

  String convertUtcToIst(String utcTimestamp) {
    DateTime utcDateTime = DateTime.parse(utcTimestamp);
    DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    String formattedDate = DateFormat('MMM dd, yyyy').format(istDateTime);
    String formattedTime = DateFormat('hh:mm a').format(istDateTime);
    return '$formattedDate $formattedTime';
  }

  String convertUtcToIstFormatStringToDDMMYYYYHHMMA(String date) {
    DateTime utcDateTime = DateTime.parse(date);
    DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    String formattedDateTimeString = DateFormat('dd/MM/yyyy hh:mm:ss a').format(istDateTime);
    return formattedDateTimeString;
  }

  String convertUtcToIstFormatStringToDDMMYYYYHHMMA2(String date) {
    DateTime utcDateTime = DateTime.parse(date);
    DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    String formattedDateTimeString = DateFormat('dd-MM-yyyy hh:mm a').format(istDateTime);
    return formattedDateTimeString;
  }
}
