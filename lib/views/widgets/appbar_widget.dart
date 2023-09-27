import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: white,
    automaticallyImplyLeading: false,
    title: boldText(text: title, color: fontGrey, size: 16.0),
    actions: [
      Center(
        child: normalText(
            text: intl.DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now()),
            color: darkGrey,
            size: 16.0),
      ),
      10.widthBox
    ],
  );
}
