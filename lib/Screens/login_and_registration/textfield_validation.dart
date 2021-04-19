import 'package:firebase_auth/firebase_auth.dart';

class Validation {
  // Validation methods
  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0  هذه القيمة غير صالحة';
    }
    return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0  هذه القيمة غير صالحة';
    }
    return null;
  }

  String validateDate(String value) {
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0  هذه القيمة غير صالحة';
    }
    return null;
  }

  String validateMessage(String value) {
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    }
    return null;
  }

  String validateDoubleNumber(String value) {
    // regular expression for integer or double numbers only
    String pattern = r'[0-9.,]+';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0  هذه القيمة غير صالحة';
    }
    return null;
  }

  String validateIntegerNumber(String value) {
    // regular expression for integer numbers only
    String pattern = r'^[0-9]+$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0  هذه القيمة غير صالحة';
    }
    return null;
  }

  String validateDropDownMenue(String value) {
    if (value == null) {
      return ' \u26A0 هذاالحقل مطلوب';
    }
    return null;
  }

  String validateEmailLogin(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!FirebaseAuth.instance.currentUser.email.contains(value)) {
      return ' \u26A0  هذه القيمة غير صالحة';
    }
    return null;
  }

  String validateEmailReset(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!regExp.hasMatch(value)) {
      return ' \u26A0 البريد الإلكتروني غير موجود ';
    }
    return null;
  }

  String validatePasswordLogin(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    }
    return null;
  }

  String validatePassword(String value) {
    //At least one upper case
    String pattern1 = r'^(?=.*?[A-Z])';
    String pattern2 = r'^(?=.*?[a-z])';
    String pattern3 = r'^(?=.*?[0-9])';
    String pattern4 = r'^(?=.*?[#?!@$%^&*-])';
    String pattern5 = r'^.{8,}$';

    RegExp regExp1 = RegExp(pattern1);
    RegExp regExp2 = RegExp(pattern2);
    RegExp regExp3 = RegExp(pattern3);
    RegExp regExp4 = RegExp(pattern4);
    RegExp regExp5 = RegExp(pattern5);

    if (value.length == 0) {
      return ' \u26A0 هذا  الحقل مطلوب';
    } else if (!regExp1.hasMatch(value)) {
      return ' \u26A0   كلمة السر يجب ان تحتوي على حرف كبير، مثل : A-Z ';
    } else if (!regExp2.hasMatch(value)) {
      return ' \u26A0 كلمة السر يجب ان تحتوي على حرف صغير، مثل: a-z ';
    } else if (!regExp3.hasMatch(value)) {
      return ' \u26A0   كلمة السر يجب ان تحتوي على رقم واحد على الأقل، \nمثل :123..';
    } else if (!regExp4.hasMatch(value)) {
      return ' \u26A0 كلمة السر يجب ان تحتوي على أحرف خاصة،\n مثل: @  .  -  _ ';
    } else if (!regExp5.hasMatch(value)) {
      return ' \u26A0 كلمة السر يجب ان لا تقل على 8 أحرف ';
    }
    return null;
  }
}
