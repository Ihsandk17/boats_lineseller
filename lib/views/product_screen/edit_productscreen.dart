import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/products_controller.dart';
import 'package:boats_lineseller/views/product_screen/product_screen.dart';
import 'package:boats_lineseller/views/widgets/custom_textfield.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';
import 'package:get/get.dart';

class EditProductScreen extends StatefulWidget {
  final String productId; // The product ID passed from the ProductScreen

  // ignore: prefer_const_constructors_in_immutables
  EditProductScreen({super.key, required this.productId});

  @override
  // ignore: library_private_types_in_public_api
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ProductsController controller = Get.find<ProductsController>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final product = await controller.getProductById(widget.productId);
    setState(() {
      nameController.text = product['p_name'] ?? '';
      descriptionController.text = product['p_desc'] ?? '';
      priceController.text = product['p_price'] ?? '';
      quantityController.text = product['p_quantity'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: white)),
        title: boldText(text: editproduct),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextField(
                  controller: nameController, label: "Product Name"),
              10.heightBox,
              customTextField(controller: priceController, label: 'Price'),
              10.heightBox,
              customTextField(
                  controller: quantityController, label: 'Quantity'),
              10.heightBox,
              customTextField(
                  isDesc: true,
                  controller: descriptionController,
                  label: 'Description'),
              ElevatedButton(
                onPressed: () async {
                  // Update the product details in the controller
                  await controller.updateProduct(
                    // context,
                    widget.productId,
                    nameController.text,
                    descriptionController.text,
                    priceController.text,
                    quantityController.text,
                  );

                  // Navigate back to the product details screen or the product list screen
                  Get.offAll(() => const ProductScreen());
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
