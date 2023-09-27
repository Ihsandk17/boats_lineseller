import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/home_controller.dart';
import 'package:boats_lineseller/views/orders_screen/orders_screen.dart';
import 'package:boats_lineseller/views/product_screen/product_screen.dart';
import 'package:boats_lineseller/views/profile_screen/profile_screen.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navScreens = [
      const HomeScreen(),
      const ProductScreen(),
      const OrdersScreen(),
      const ProfileScreen()
    ];
    var bottomNavbar = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: dashboard),
      const BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          //Image.asset(icProducts, color: darkGrey, width: 24),
          label: products),
      const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          //Image.asset(icOrders, color: darkGrey, width: 24),
          label: orders),
      const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          //Image.asset(icGeneralSetting, color: darkGrey, width: 24),
          label: settings)
    ];

    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) {
            controller.navIndex.value = index;
          },
          currentIndex: controller.navIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: purpleColor,
          unselectedItemColor: darkGrey,
          items: bottomNavbar,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreens.elementAt(controller.navIndex.value))
          ],
        ),
      ),
    );
  }
}
