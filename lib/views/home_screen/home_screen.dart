import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/services/store_services.dart';
import 'package:boats_lineseller/views/product_screen/product_details.dart';
import 'package:boats_lineseller/views/widgets/loading_indicator.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/dashbord_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;

            data = data.sortedBy((a, b) =>
                a['p_wishlist'].length.compareTo(b['p_wishlist'].length));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashbordButton(context,
                          title: products,
                          count: "${data.length}",
                          icon: icProducts),
                      //show number of orders
                      FutureBuilder<int>(
                        future: StoreServices.getOrderCount(
                            currentUser!.uid), //calling getOrderCount method
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loadingIndicator(circleColor: white);
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            int orderCount = snapshot.data ?? 0;
                            return dashbordButton(context,
                                title: orders,
                                count: "$orderCount",
                                icon: icOrders);
                          }
                        },
                      ),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashbordButton(context,
                          title: rating, count: "4.1", icon: icStar),
                      //show total sales, it will be that which delivered
                      FutureBuilder<int>(
                        future: StoreServices.getTotalSales(currentUser!.uid,
                            true), // call the method wich getting total sales from storeservices
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loadingIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            int orderCount = snapshot.data ?? 0;
                            return dashbordButton(context,
                                title: totalSales,
                                count: "$orderCount",
                                icon: icOrders);
                          }
                        },
                      ),
                    ],
                  ),
                  10.heightBox,
                  const Divider(),
                  10.heightBox,
                  boldText(text: popular, color: purpleColor, size: 16.0)
                      .box
                      .topRounded()
                      .padding(const EdgeInsets.only(
                          left: 70, right: 70, top: 12, bottom: 12))
                      .color(Colors.grey.shade100)
                      .make(),
                  14.heightBox,
                  //Papular product list
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      data.length,
                      (index) => data[index]['p_wishlist'].length == 0
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ListTile(
                                onTap: () {
                                  Get.to(() => ProductDetails(
                                        data: data[index],
                                      ));
                                },
                                leading: Image.network(
                                  data[index]['p_imgs'][0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                title: boldText(
                                    text: "${data[index]['p_name']}",
                                    color: fontGrey),
                                subtitle: normalText(
                                    text: "\$${data[index]['p_price']}",
                                    color: darkGrey),
                              ).box.white.roundedSM.shadowSm.make(),
                            ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
