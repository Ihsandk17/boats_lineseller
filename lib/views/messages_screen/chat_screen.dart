import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/controllers/chats_controller.dart';
import 'package:boats_lineseller/services/store_services.dart';
import 'package:boats_lineseller/views/widgets/loading_indicator.dart'
    show loadingIndicator;
import 'package:boats_lineseller/views/widgets/text_style.dart' show boldText;
import 'package:boats_lineseller/views/widgets/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../widgets/loading_indicator.dart';
import 'components/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var senderName = Get.arguments[0];
    // ignore: unused_local_variable
    var friendId = Get.arguments[1];
    var chatDocId = Get.arguments[2]; // Get the chatDocId from arguments
    var controller =
        Get.put(ChatsController(chatDocId)); // Pass it to the controller

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: darkGrey,
              )),
          title: boldText(
              text: controller.friendName, size: 16.0, color: fontGrey)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Obx(
            () => controller.isLoading.value
                ? Center(
                    child: loadingIndicator(),
                  )
                : Expanded(
                    child: StreamBuilder(
                        stream: StoreServices.getChatMessages(
                            controller.chatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: "Send a message..."
                                  .text
                                  .color(darkGrey)
                                  .make(),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!.docs
                                  .mapIndexed((currentValue, index) {
                                var data = snapshot.data!.docs[index];

                                return Align(
                                    alignment: data['uid'] == currentUser!.uid
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: chatBubble(data));
                              }).toList(),
                            );
                          }
                        }),
                  ),
          ),
          10.heightBox,
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: controller.msgController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textfieldGrey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textfieldGrey)),
                    hintText: "Type a message..."),
              )),
              IconButton(
                onPressed: () {
                  controller.sendMsg(controller.msgController.text);
                  controller.msgController.clear();
                },
                icon: const Icon(Icons.send),
                color: red,
              )
            ],
          )
              .box
              .height(80)
              .margin(const EdgeInsets.only(bottom: 8))
              .padding(const EdgeInsets.all(12))
              .make()
        ]),
      ),
    );
  }
}
