import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/products_controller.dart';
import 'package:boats_lineseller/views/product_screen/components/rating_stars.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';
import 'package:get/get.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(ProductsController()); // Get the ProductsController instance

    // Call calculateAverageRating to update average rating
    controller.calculateAverageRating(data['id']);

// Convert data['p_colors'] to List<String>
    List<String> colorList = (data['p_colors'] as List<dynamic>)
        .map((color) => color.toString())
        .toList();
// Update the colors in your controller
    controller.updateColorsFromFirebase(colorList);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: darkGrey)),
        title: boldText(text: "${data['p_name']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //swiper section
            VxSwiper.builder(
                autoPlay: true,
                height: 350,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                itemCount: data['p_imgs'].length,
                itemBuilder: (context, index) {
                  return Image.network(
                    data['p_imgs'][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                      text: "${data['p_name']}", color: fontGrey, size: 16.0),
                  10.heightBox,
                  boldText(text: "Category:", color: fontGrey, size: 12.0),
                  10.heightBox,
                  Row(
                    children: [
                      normalText(
                          text: "${data['p_category']}",
                          color: fontGrey,
                          size: 12.0),
                      10.widthBox,
                      normalText(
                          text: "${data['p_subcategory']}",
                          color: fontGrey,
                          size: 12.0),
                    ],
                  ),
                  10.heightBox,
                  // //Rating
                  // VxRating(
                  //   isSelectable: false,
                  //   value: double.parse(data['p_rating']),
                  //   onRatingUpdate: (value) {},
                  //   normalColor: textfieldGrey,
                  //   selectionColor: golden,
                  //   count: 5,
                  //   size: 25,
                  //   maxRating: 5,
                  // ),

                  //Show Rating in stars, in numbersm and total rating
                  FutureBuilder<int>(
                    future: controller.totalRating(data['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // or a loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final numberOfRatings = snapshot.data ?? 0;
                        return RatingStars(
                          rating: controller.averageRating.value,
                          maxRating: 5,
                          numberOfRatings: numberOfRatings,
                        );
                      }
                    },
                  ),

                  10.heightBox,
                  boldText(
                      text: "\$${data['p_price']}", color: red, size: 18.0),
                  20.heightBox,
                  //color section
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: boldText(text: "Color:", color: fontGrey),
                            ),
                            Row(
                              children: List.generate(
                                controller.selectedColors.length,
                                (index) => controller.selectedColors[index] !=
                                        null
                                    ? VxBox()
                                        .size(40, 40)
                                        .roundedFull
                                        .color(
                                            controller.selectedColors[index]!)
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 4))
                                        .make()
                                    : const SizedBox(),
                              ),
                            )
                          ],
                        ),
                        10.heightBox,
                        //Quantity Row
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child:
                                  boldText(text: "quantity:", color: fontGrey),
                            ),
                            normalText(
                                text: "${data['p_quantity']} units",
                                color: fontGrey),
                          ],
                        ),
                      ],
                    ).box.padding(const EdgeInsets.all(8)).make(),
                  ),
                  const Divider(),
                  20.heightBox,
                  //Discreption section
                  boldText(
                    text: "Descreption",
                    color: fontGrey,
                  ),
                  10.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        normalText(text: "${data['p_desc']}", color: fontGrey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
