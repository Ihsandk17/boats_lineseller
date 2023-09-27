import 'package:boats_lineseller/const/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class ChatsController extends GetxController {
  ChatsController(this.chatDocId); // Constructor to receive chatDocId

  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  late String chatDocId;
  var isLoading = false.obs;

  getChatId() async {
    isLoading(true);
    // Use the chatDocId parameter to fetch the chat data
    DocumentSnapshot chatSnapshot = await chats.doc(chatDocId).get();
    if (chatSnapshot.exists) {
      // Chat exists, extract chat data
      Map<String, dynamic> chatData =
          chatSnapshot.data() as Map<String, dynamic>;
      // Set the values for the current chat based on the chatData
      friendName = chatData['sender_name'];
      friendId = chatData['fromId'];
      chatDocId = chatSnapshot.id; // Update chatDocId if needed
    } else {
      // Chat doesn't exist, create a new one
      DocumentReference newChatDocRef = await chats.add({
        'created_on': null,
        'last_msg': '',
        'users': {currentId: null, friendId: null},
        'toId': '',
        'fromId': '',
        'friend_name': friendName,
        'sender_name': senderName,
      });
      chatDocId = newChatDocRef.id; // Update chatDocId with the new ID
    }

    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        // 'toId': friendId,
        // 'fromId': currentId,
      });
      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
