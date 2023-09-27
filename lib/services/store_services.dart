import 'package:boats_lineseller/const/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }

  static getProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  //get all chats messages
  static getChatMessages(chatDocId) {
    return firestore
        .collection(chatsCollection)
        .doc(chatDocId)
        .collection('messages')
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getMessages(uid) {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  //Method that count number of orders for homesreen and this is out of the class
  static Future<int> getOrderCount(String vendorId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('orders')
        .where('vendors', arrayContains: vendorId)
        .get();

    return snapshot.docs.length;
  }

  static Future<int> getTotalSales(String vendorId, bool orderConfirmed) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('orders')
        .where('vendors', arrayContains: vendorId)
        .where('order_delivered', isEqualTo: true)
        .get();

    return snapshot.docs.length;
  }
}
