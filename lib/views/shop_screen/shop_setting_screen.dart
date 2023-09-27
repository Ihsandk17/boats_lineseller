import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/profile_controller.dart';
import 'package:boats_lineseller/views/widgets/custom_textfield.dart';
import 'package:boats_lineseller/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../widgets/text_style.dart';

class ShopSettingScreen extends StatelessWidget {
  const ShopSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: shopSettings, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.updateShop(
                        shopname: controller.shopNameController.text,
                        shopaddress: controller.shopAddressController.text,
                        shopmobile: controller.shopMobileController.text,
                        shopwebsite: controller.shopWebsiteController.text,
                        shopdesc: controller.shopDescController.text,
                      );
                      // Clear the text fields
                      controller.shopNameController.clear();
                      controller.shopAddressController.clear();
                      controller.shopMobileController.clear();
                      controller.shopWebsiteController.clear();
                      controller.shopDescController.clear();

                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Updated");
                    },
                    child: normalText(text: save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                10.heightBox,
                customTextField(
                    label: shopname,
                    hint: nameHint,
                    controller: controller.shopNameController),
                10.heightBox,
                customTextField(
                    label: address,
                    hint: shopAddressHint,
                    controller: controller.shopAddressController),
                10.heightBox,
                customTextField(
                    label: mobile,
                    hint: shopMobileHint,
                    controller: controller.shopMobileController),
                10.heightBox,
                customTextField(
                    label: website,
                    hint: shopWebsiteHint,
                    controller: controller.shopWebsiteController),
                10.heightBox,
                customTextField(
                    isDesc: true,
                    label: descripiton,
                    hint: shopDescHint,
                    controller: controller.shopDescController)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
