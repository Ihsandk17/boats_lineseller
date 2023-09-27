import 'package:boats_lineseller/const/const.dart';

Widget applogoWidget() {
  //using Velocity X here which is an UI Library

  return Image.asset(icLogo)
      .box
      .color(purpleColor)
      .size(77, 77)
      .padding(
        const EdgeInsets.all(8),
      )
      .rounded
      .make();
}
