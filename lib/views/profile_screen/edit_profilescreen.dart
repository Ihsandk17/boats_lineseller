import 'dart:io';

import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/profile_controller.dart';
import 'package:boats_lineseller/views/widgets/loading_indicator.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';
import 'package:get/get.dart';

import '../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({super.key, this.username});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      //condition for if Image is not sellected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData["imageUrl"];
                      }
                      //if password matches data base

                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text);

                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpassController.text);
                        // ignore: use_build_context_synchronously
                        VxToast.show(context, msg: "Updated");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.snapshotData['password']);
                        // ignore: use_build_context_synchronously
                        VxToast.show(context, msg: "Updated");
                      } else {
                        // ignore: use_build_context_synchronously
                        VxToast.show(context, msg: "some error occur");
                        controller.isloading(false);
                      }
                    },
                    child: boldText(text: save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //if data image url and controller path is empty
                controller.snapshotData['imageUrl'] == '' &&
                        controller.profileImgPath.isEmpty
                    ? Image.asset(
                        imgProduct,
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()

                    //if data is not empty but controller path is empty
                    : controller.snapshotData['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.network(controller.snapshotData['imageUrl'],
                                width: 100, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make()
                        //else controller path is not empty but data image url is
                        : Image.file(File(controller.profileImgPath.value),
                                width: 100, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
                10.heightBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: white),
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: normalText(text: changeImage, color: fontGrey),
                ),
                10.heightBox,
                const Divider(color: white),
                10.heightBox,
                customTextField(
                    label: name,
                    hint: "eg. Ihsan ullah",
                    controller: controller.nameController),
                10.heightBox,
                Align(
                    alignment: Alignment.centerLeft,
                    child: normalText(
                      text: "Change password here",
                      color: green,
                    )),
                10.heightBox,
                customTextField(
                    label: password,
                    hint: passwordHint,
                    controller: controller.oldpassController),
                10.heightBox,
                customTextField(
                    label: confirmPass,
                    hint: passwordHint,
                    controller: controller.newpassController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
