import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// Just for demo
const productDemoImg1 = "https://i.imgur.com/CGCyp1d.png";
const productDemoImg2 = "https://i.imgur.com/AkzWQuJ.png";
const productDemoImg3 = "https://i.imgur.com/J7mGZ12.png";
const productDemoImg4 = "https://i.imgur.com/q9oF9Yq.png";
const productDemoImg5 = "https://i.imgur.com/MsppAcx.png";
const productDemoImg6 = "https://i.imgur.com/JfyZlnO.png";

const demoBookImg1 =
    "https://i.pinimg.com/originals/f8/94/a8/f894a88ea42aad616240b1a6cf925bac.jpg";
const demoBookImg2 = "https://m.media-amazon.com/images/I/61kRkfsIMUL.jpg";
const demoBookImg3 = "https://m.media-amazon.com/images/I/91bYsX41DVL.jpg";
const demoBookImg4 = "https://m.media-amazon.com/images/I/51u8ZRDCVoL.jpg";

// End For demo

const grandisExtendedFont = "Grandis Extended";

// On color 80, 60.... those means opacity

const Color primaryColor = Color(0xFFee1c23);

const MaterialColor primaryMaterialColor = MaterialColor(
  0xFFef5350,
  <int, Color>{
    50: Color(0xFFffebee),
    100: Color(0xFFffcdd2),
    200: Color(0xFFef9a9a),
    300: Color(0xFFe57373),
    400: Color(0xFFef5350),
    500: Color(0xFFee1c23),
    600: Color(0xFFe53935),
    700: Color(0xFFd32f2f),
    800: Color(0xFFc62828),
    900: Color(0xFFb71c1c),
  },
);

const Color blackColor = Color(0xFF16161E);
const Color blackColor80 = Color(0xFF45454B);
const Color blackColor60 = Color(0xFF737378);
const Color blackColor40 = Color(0xFFA2A2A5);
const Color blackColor20 = Color(0xFFD0D0D2);
const Color blackColor10 = Color(0xFFE8E8E9);
const Color blackColor5 = Color(0xFFF3F3F4);

const Color whiteColor = Colors.white;
const Color whileColor80 = Color(0xFFCCCCCC);
const Color whileColor60 = Color(0xFF999999);
const Color whileColor40 = Color(0xFF666666);
const Color whileColor20 = Color(0xFF333333);
const Color whileColor10 = Color(0xFF191919);
const Color whileColor5 = Color(0xFF0D0D0D);

const Color greyColor = Color(0xFFB8B5C3);
const Color lightGreyColor = Color(0xFFF8F8F9);
const Color darkGreyColor = Color(0xFF1C1C25);
// const Color greyColor80 = Color(0xFFC6C4CF);
// const Color greyColor60 = Color(0xFFD4D3DB);
// const Color greyColor40 = Color(0xFFE3E1E7);
// const Color greyColor20 = Color(0xFFF1F0F3);
// const Color greyColor10 = Color(0xFFF8F8F9);
// const Color greyColor5 = Color(0xFFFBFBFC);

const Color purpleColor = Color(0xFF7B61FF);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character')
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: "Enter a valid email address"),
]);

final mobileValidator = MultiValidator([
  RequiredValidator(errorText: 'Mobile is required'),
  MinLengthValidator(10, errorText: 'Mobile must be at least 10 digits long'),
  MaxLengthValidator(10, errorText: 'Mobile must be at least 10 digits long'),
]);

const pasNotMatchErrorText = "passwords do not match";

// Api
enum ApiMessage {
  success,
  internalServerError,
  somethingWantWrongError,
  apiError,
  permissionError
}

extension ApiMessageExtension on ApiMessage {
  String get asString {
    switch (this) {
      case ApiMessage.apiError:
        return 'Api Error';
      case ApiMessage.internalServerError:
        return 'Internal Server Error';
      case ApiMessage.somethingWantWrongError:
        return 'Something Want Wrong';
      case ApiMessage.success:
        return 'Success';
      case ApiMessage.permissionError:
        return 'Permission Denied';
      default:
        return 'Something Want Wrong';
    }
  }
}

class ApiResponse {
  dynamic data;
  int? dataCount;
  ApiMessage? message;

  ApiResponse({this.data, this.message, this.dataCount});
}
