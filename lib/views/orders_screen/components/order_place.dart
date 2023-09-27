import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';

Widget orderPlaceDetails({
  title1,
  title2,
  d1,
  d2,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: title1, color: purpleColor),
              boldText(text: d1, color: red)
            ],
          ),
        ),
        SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: title2, color: purpleColor),
              boldText(text: d2, color: fontGrey)
            ],
          ),
        ),
      ],
    ),
  );
}
