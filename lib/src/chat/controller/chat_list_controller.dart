import 'dart:async';

import 'package:get/get.dart';
import 'package:nero_app/src/chat/model/chat_display_info.dart';
import 'package:nero_app/src/chat/model/chat_group_model.dart';
import 'package:nero_app/src/chat/repository/chat_repository.dart';
import 'package:nero_app/src/common/model/product.dart';
import 'package:nero_app/src/product/repository/product_repository.dart';
import 'package:nero_app/src/user/controller/user_repository.dart';
import 'package:nero_app/src/user/model/user_model.dart';

class ChatListController extends GetxController {
  final ChatRepository _chatRepository;
  final ProductRepository _productRepository;
  final UserRepository _userRepository;
  final String myUid;

  final RxList<Stream<List<ChatDisplayInfo>>> chatStreams =
      <Stream<List<ChatDisplayInfo>>>[].obs;

  ChatListController(this._chatRepository,
      this._productRepository,
      this._userRepository,
      this.myUid,);

  @override
  void onInit() {
    super.onInit();
    var productId = Get.arguments['productId'] as String?;
    if (productId != null) {
      _loadAllProductChatList(productId);
    }
  }

  void _loadAllProductChatList(String productId) async {
    var result = await _chatRepository.loadChatInfo(productId);
    if (result != null) {
      loadChatInfoStream(result);
    }
  }

  void loadChatInfoStream(ChatGroupModel info) async {
    info.chatters?.forEach((chatDoc) {
      var chatStreamData = _chatRepository.loadChatInfoOneStream(
          info.productId ?? '', chatDoc).transform<List<ChatDisplayInfo>>(
        StreamTransformer.fromHandlers(
          handleData: (docSnap, sink) {
            if (docSnap.isNotEmpty) {
              var chatModels = docSnap.map<ChatDisplayInfo>((item) => ChatDisplayInfo(
                ownerUid: info.owner,
                customerUid: chatDoc,
                isOwner: info.owner == myUid,
                productId: info.productId,
                chatModel: item,
              )).toList();
              sink.add(chatModels);
            }
          },
        ),
      );
      chatStreams.add(chatStreamData);
    });
  }

  Future<UserModel?> loadUserInfo(String uid) async { // 닉네임 전달
    return await _userRepository.findUserOne(uid);
  }
  
  Future<Product?> loadProductInfo(String productId) async { // 상품 반환
    return await _productRepository.getProduct(productId);
  }
}
