import 'package:boats_lineseller/const/const.dart';
import 'package:boats_lineseller/services/store_services.dart';
import 'package:boats_lineseller/views/messages_screen/chat_screen.dart';
import 'package:boats_lineseller/views/widgets/loading_indicator.dart';
import 'package:boats_lineseller/views/widgets/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: darkGrey,
              )),
          title: boldText(text: messages, size: 16.0, color: fontGrey)),
      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!".text.color(darkGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var t = data[index]['created_on'] == null
                                ? DateTime.now()
                                : data[index]['created_on'].toDate();
                            var time = intl.DateFormat("h:mma").format(t);

                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Get.to(() => const ChatScreen(), arguments: [
                                    data[index]['sender_name'],
                                    data[index]['fromId'],
                                    data[index].id
                                  ]);
                                },
                                leading: const CircleAvatar(
                                  backgroundColor: red,
                                  child: Icon(
                                    Icons.person,
                                    color: white,
                                  ),
                                ),
                                title: "${data[index]['sender_name']}"
                                    .text
                                    .color(darkGrey)
                                    .make(),
                                subtitle:
                                    "${data[index]['last_msg']}".text.make(),
                                trailing: normalText(
                                    text: time,
                                    color: darkGrey), // Display the time here
                              ),
                            );
                          }))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
