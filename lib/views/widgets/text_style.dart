import 'package:boats_lineseller/const/const.dart';

Widget normalText({text, color = Colors.white, size = 14.0}) {
  return "$text".text.color(color).size(size).make();
}

Widget boldText({text, color = Colors.white, size = 14.0}) {
  return "$text".text.color(color).size(20.0).make();
}
