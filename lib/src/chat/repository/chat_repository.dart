import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRepository extends GetxService {
  late FirebaseFirestore db;

  ChatRepository(this.db);
}
