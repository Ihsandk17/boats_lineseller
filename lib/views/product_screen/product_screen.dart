import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/products_controller.dart';
import 'package:boats_lineseller/services/store_services.dart';
import 'package:boats_lineseller/views/product_screen/add_product.dart';
import 'package:boats_lineseller/views/product_screen/edit_productscreen.dart';
import 'package:boats_lineseller/views/product_screen/product_details.dart';
import 'package:boats_lineseller/views/widgets/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/text_style.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    return Scaffold(
        //add product button
        floatingActionButton: FloatingActionButton(
          backgroundColor: purpleColor,
          onPressed: () async {
            await controller.getCategories();
            controller.populateCategoryList();
            Get.to(() => const AddProduct());
          },
          child: const Icon(Icons.add),
        ),
        appBar: appbarWidget(products),
        body: StreamBuilder(
          stream: StoreServices.getProducts(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      data.length,
                      (index) => Card(
                        child: ListTile(
                          onTap: () {
                            Get.to(() => ProductDetails(
                                  data: data[index],
                                ));
                          },
                          leading: Image.network(data[index]['p_imgs'][0],
                              width: 100, height: 100, fit: BoxFit.cover),

                          title: boldText(
                              text: "${data[index]['p_name']}",
                              color: fontGrey),
                          subtitle: Row(children: [
                            normalText(
                                text: "\$${data[index]['p_price']}",
                                color: darkGrey),
                            10.widthBox,
                            boldText(
                                text: data[index]['is_featured'] == true
                                    ? "Featured"
                                    : '',
                                color: green),
                          ]),
                          //Popup Menu
                          trailing: VxPopupMenu(
                            menuBuilder: () => Column(
                              children: List.generate(
                                popupMenuTitles.length,
                                (i) => Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        popupMenuIcons[i],
                                        color: data[index]['featured_id'] ==
                                                    currentUser!.uid &&
                                                i == 0
                                            ? green
                                            : darkGrey,
                                      ),
                                      10.widthBox,
                                      normalText(
                                          text: data[index]['featured_id'] ==
                                                      currentUser!.uid &&
                                                  i == 0
                                              ? 'Remove featured'
                                              : popupMenuTitles[i],
                                          color: darkGrey)
                                    ],
                                  ).onTap(() {
                                    switch (i) {
                                      case 0:
                                        if (data[index]['is_featured'] ==
                                            true) {
                                          controller
                                              .removeFeatured(data[index].id);
                                          VxToast.show(context,
                                              msg:
                                                  "Removed! Now you don't have any product in featured");
                                        } else {
                                          controller.addFeatured(
                                              data[index].id, context);
                                        }
                                        break;
                                      case 1: // Edit option in the popup menu
                                        // Close the current screen (ProductScreen)
                                        Navigator.of(context).pop();
                                        Get.to(() => EditProductScreen(
                                              productId: data[index][
                                                  'p_id'], // Pass the product ID to identify the product
                                            ));
                                        break;
                                      case 2:
                                        controller.removeProduct(
                                            data[index].id, context);
                                        break;
                                      default:
                                    }
                                  }),
                                ),
                              ),
                            ).box.white.width(200).roundedSM.make(),
                            clickType: VxClickType.singleClick,
                            child: const Icon(Icons.more_vert_rounded),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
