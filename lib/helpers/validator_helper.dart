import 'package:memstuff_manha/helpers/date_helper.dart';

class ValidatorHelper {
  static String isValidText(String text) {
    return text.isEmpty ? 'Campo obrigatório' : null;
  }

  static String dateValidator(String text) {
    return DateHelper.parse(text).isAfter(DateTime.now())
        ? 'Data Inválida'
        : null;
  }
}
