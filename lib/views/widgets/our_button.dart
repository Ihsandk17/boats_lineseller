import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';

Widget ourButton({title, color = purpleColor, onPress}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // ignore: deprecated_member_use
          primary: color,
          padding: const EdgeInsets.all(12)),
      onPressed: onPress,
      child: normalText(text: title, size: 16.0));
}
