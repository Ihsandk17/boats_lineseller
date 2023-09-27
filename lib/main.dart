import 'package:boats_lineseller/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'const/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BoatsLineseller());
}

class BoatsLineseller extends StatelessWidget {
  const BoatsLineseller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      home: const Wrapper(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent, elevation: 0.0)),
    );
  }
}
