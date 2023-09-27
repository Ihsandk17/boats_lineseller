import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/views/auth_screen/login_screen.dart';
import 'package:boats_lineseller/views/home_screen/home.dart';
import 'package:boats_lineseller/views/widgets/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //creating a method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //using getX
      //Get.to(() => const LoginScreen());
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(() => const LoginScreen());
        } else {
          Get.to(const Home());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      body: Center(
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              splashbg,
              width: 300,
            ),
          ),
          10.heightBox,
          applogoWidget(),
          10.heightBox,
          appname.text.size(16).white.make(),
          5.heightBox,
          appversion.text.white.make(),
          //Spacer is used for also space to keep responsive
          const Spacer(),
          credits.text.white.make(),
          30.heightBox,
          //splash screen UI copletet
        ]),
      ),
    );
  }
}
