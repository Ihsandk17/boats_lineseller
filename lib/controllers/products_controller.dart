import 'dart:developer';
import 'dart:io';

import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../models/category_model.dart';

class ProductsController extends GetxController {
  RxDouble averageRating = 0.0.obs; // Rx variable to store average rating

  var isLoading = false.obs;

  //Text field controller for add product
  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];

  var pImagesList = RxList<dynamic>.generate(3, (index) => null);
  var pImagesLinks = [];

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  // List to store selected colors
  var selectedColors = <Color?>[].obs;

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();

    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategory(cat) {
    subcategoryList.clear();
    var data = category.where((element) => element.name == cat).toList();
    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
        log(pImagesList.toString());
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var distination = 'images/vendors${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(distination);
        try {
          await ref.putFile(item);
          var n = await ref.getDownloadURL();
          pImagesLinks.add(n);
        } catch (e) {
          // ignore: avoid_print
          print("Error uploading file: $e");
        }
      }
    }
  }

  uploadProduct(context) async {
    var store = firestore.collection(productsCollection).doc();

    var storeId = firestore.collection(productsCollection).doc();
    String productId = storeId.id; // Get a unique product ID

    // Convert selected colors to hex color values (strings)
    List<String> selectedColorsHex = selectedColors
        .map((color) => color != null ? color.value.toRadixString(16) : "")
        .toList();

    await store.set({
      'id': productId,
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': FieldValue.arrayUnion(selectedColorsHex),
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'p_rating': "5.0",
      'vendor_id': currentUser!.uid,
      'featured_id': '',
    });
    isLoading(false);
    resetState();
    VxToast.show(context, msg: "Product Uploaded");
  }

  addFeatured(docId, context) async {
    var featuredProduct = await firestore
        .collection(productsCollection)
        .where('featured_id', isEqualTo: currentUser!.uid)
        .get();
    if (featuredProduct.docs.isNotEmpty) {
      VxToast.show(context, msg: "Only one product can be featured");
    } else {
      await firestore.collection(productsCollection).doc(docId).set(
          {'featured_id': currentUser!.uid, 'is_featured': true},
          SetOptions(merge: true));
      VxToast.show(context, msg: "Added in featured");
    }
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set(
        {'featured_id': '', 'is_featured': false}, SetOptions(merge: true));
  }

  removeProduct(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).delete();
    VxToast.show(context, msg: "Product Remove");
  }

  // Toggle color selection
  void toggleColorSelection(Color color) {
    if (isColorSelected(color)) {
      selectedColors.remove(color); // Deselect the color if already selected
    } else {
      if (selectedColors.length < 3) {
        selectedColors.add(color);
      } else {
        selectedColors.removeAt(0); // Deselect the first selected color
        selectedColors.add(color); // Add the new selected color
      }
    }
  }

  // Check if a color is selected
  bool isColorSelected(Color color) {
    return selectedColors.contains(color);
  }

  // Update colors from Firebase
  void updateColorsFromFirebase(List<String> colors) {
    selectedColors.clear();
    for (String colorHex in colors) {
      selectedColors.add(Color(int.parse(colorHex, radix: 16)));
    }
  }

  Future<Color> fetchColorFromHex(String hexColor) async {
    // Convert hexadecimal color string to Color object
    return Color(int.parse(hexColor, radix: 16)).withOpacity(1.0);
  }

  //clear the fields and other
  void resetState() {
    pnameController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquantityController.clear();
    categoryList.clear();
    subcategoryList.clear();
    pImagesList
        .assignAll(List.generate(3, (index) => null)); // Reset images list
    selectedColors.clear(); // Reset selected colors
  }

  //get product for editing
  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      final DocumentSnapshot productSnapshot =
          await firestore.collection(productsCollection).doc(productId).get();

      if (productSnapshot.exists) {
        return productSnapshot.data() as Map<String, dynamic>;
      } else {
        // Handle the case where the product doesn't exist
        return <String, dynamic>{};
      }
    } catch (e) {
      // Handle any errors that occur during the database query
      // ignore: avoid_print
      print('Error fetching product details: $e');
      return <String, dynamic>{};
    }
  }

  //Update product method is used for edit data to update in the firebase
  Future<void> updateProduct(
    //context,
    String productId,
    String updatedName,
    String updatedDescription,
    String updatedPrice,
    String updatedQuantity,
  ) async {
    try {
      await firestore.collection(productsCollection).doc(productId).update({
        'p_name': updatedName,
        'p_desc': updatedDescription,
        'p_price': updatedPrice,
        'p_quantity': updatedQuantity,
        // Add other fields to update here if needed
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error updating product: $e');
      // Handle any errors that occur during the update process.
      // VxToast.show(context, msg: e.toString());
    }
  }

  //calculate Average rating
  calculateAverageRating(String productId) {
    final ratingsRef = FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('ratingsAndReviews');

    ratingsRef.get().then((querySnapshot) {
      if (querySnapshot.size == 0) {
        // No ratings and reviews available
        averageRating.value = 0.0; // Set to 0 if no ratings exist
      } else {
        double totalRating = 0.0;
        int numberOfRatings = 0;

        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((document) {
          final rating =
              document['rating']; // Replace with the correct field name
          totalRating += rating;
          numberOfRatings++;
        });

        final calculatedAverage = totalRating / numberOfRatings;

        averageRating.value = calculatedAverage;
      }
    }).catchError((error) {
      // ignore: avoid_print
      print("Error calculating average rating: $error");
    });
  }

  // Method to count the number of ratings for a product
  Future<int> totalRating(String productId) async {
    try {
      final ratingsRef = FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('ratingsAndReviews');

      final querySnapshot = await ratingsRef.get();

      return querySnapshot.size;
    } catch (error) {
      // ignore: avoid_print
      print("Error counting ratings: $error");
      return 0; // Return 0 in case of an error
    }
  }
}
