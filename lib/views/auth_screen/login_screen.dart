import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../widgets/loading_indicator.dart';
import '../widgets/our_button.dart';
import '../widgets/text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              normalText(text: welcome, size: 18.0),
              20.heightBox,
              Row(
                children: [
                  Image.asset(
                    icLogo,
                    width: 70,
                    height: 70,
                  )
                      .box
                      .border(color: white)
                      .rounded
                      .padding(const EdgeInsets.all(8.0))
                      .make(),
                  10.widthBox,
                  boldText(text: appname, size: 22.0)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  60.heightBox,
                  normalText(text: loginTo, size: 16.0, color: darkGrey),
                  10.heightBox,
                  Obx(
                    () => Column(
                      children: [
                        TextFormField(
                          controller: controller.emailController,
                          decoration: const InputDecoration(
                              fillColor: textfieldGrey,
                              filled: true,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: purpleColor,
                              ),
                              hintText: emailHint),
                        ),
                        10.heightBox,
                        TextFormField(
                          obscureText: true,
                          controller: controller.passwordController,
                          decoration: const InputDecoration(
                              fillColor: textfieldGrey,
                              filled: true,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: purpleColor,
                              ),
                              hintText: passwordHint),
                        ),
                        30.heightBox,
                        SizedBox(
                          width: context.screenWidth - 100,
                          child: controller.isLoading.value
                              ? loadingIndicator()
                              : ourButton(
                                  title: login,
                                  onPress: () async {
                                    controller.isLoading(true);
                                    await controller
                                        .loginMethod(context: context)
                                        .then((value) {
                                      if (value != null) {
                                        VxToast.show(context, msg: "Logged in");
                                        controller.isLoading(false);
                                        controller.emailController.clear();
                                        controller.passwordController.clear();
                                      } else {
                                        controller.isLoading(false);
                                      }
                                    });
                                  },
                                ),
                        ),
                        8.heightBox,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {},
                              child: normalText(
                                  text: forgotPassword, color: purpleColor)),
                        )
                      ],
                    )
                        .box
                        .white
                        .rounded
                        .outerShadowMd
                        .padding(const EdgeInsets.all(8.0))
                        .make(),
                  ),
                ],
              ),
              10.heightBox,
              Center(
                child: normalText(text: anyProblem, color: lightGrey),
              ),
              const Spacer(),
              Center(
                child: normalText(text: credit),
              ),
              20.heightBox
            ],
          ),
        ),
      ),
    );
  }
}
