import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/products_controller.dart';
import 'package:boats_lineseller/views/product_screen/components/product_dropdown.dart';
import 'package:boats_lineseller/views/product_screen/components/product_images.dart';
import 'package:boats_lineseller/views/widgets/loading_indicator.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';
import 'package:get/get.dart';

import '../widgets/custom_textfield.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back, color: white)),
          title: boldText(text: "Add Product", size: 16.0),
          actions: [
            controller.isLoading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isLoading(true);
                      await controller.uploadImages();
                      // ignore: use_build_context_synchronously
                      await controller.uploadProduct(context);

                      // Clear fields after successful product upload
                      controller.resetState();
                      Get.back();
                    },
                    child: boldText(
                      text: "save",
                      color: white,
                    ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextField(
                    hint: "eg. garlic press",
                    label: "Product name",
                    controller: controller.pnameController),
                10.heightBox,
                customTextField(
                    hint: "eg. nice product",
                    label: "Descreption",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customTextField(
                    hint: "\$100",
                    label: "Price",
                    controller: controller.ppriceController),
                10.heightBox,
                customTextField(
                    hint: "eg. 30",
                    label: "Quantity",
                    controller: controller.pquantityController),
                10.heightBox,
                productDropdown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                10.heightBox,
                productDropdown("Subcategory", controller.subcategoryList,
                    controller.subcategoryvalue, controller),
                10.heightBox,
                const Divider(
                  color: white,
                ),
                8.heightBox,
                boldText(
                  text: "Chose product images",
                ),
                normalText(
                    text: "    First image will be display image",
                    color: lightGrey,
                    size: 10.0),
                10.heightBox,

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3,
                      (index) {
                        if (index < controller.pImagesList.length) {
                          return controller.pImagesList[index] != null
                              ? Image.file(
                                  controller.pImagesList[index],
                                  width: 100,
                                  height: 100,
                                ).onTap(() {
                                  controller.pickImage(index, context);
                                })
                              : productImages(label: "${index + 1}").onTap(() {
                                  controller.pickImage(index, context);
                                });
                        } else {
                          return productImages(label: "${index + 1}").onTap(() {
                            controller.pickImage(index, context);
                          });
                        }
                      },
                    ),
                  ),
                ),

                10.heightBox,
                const Divider(
                  color: white,
                ),
                8.heightBox,
                boldText(
                  text: "Chose product colors",
                ),
                10.heightBox,

                //AddProduct page

                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      staticColors.length,
                      (index) => Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              VxBox()
                                  .color(staticColors[index])
                                  .roundedFull
                                  .size(65, 65)
                                  .make()
                                  .onTap(() {
                                // Toggle color selection
                                controller
                                    .toggleColorSelection(staticColors[index]);
                              }),
                              if (controller
                                  .isColorSelected(staticColors[index]))
                                const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                          4.heightBox,
                          Text(
                            colorTitles[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ).box.margin(const EdgeInsets.only(left: 12)).make(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
