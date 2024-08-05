import 'package:get/get.dart';
import 'package:nero_app/src/chat/repository/chat_repository.dart';
import 'package:nero_app/src/common/controller/authentication_controller.dart';
import 'package:nero_app/src/common/model/product.dart';
import 'package:nero_app/src/product/repository/product_repository.dart';
import 'package:nero_app/src/user/controller/user_repository.dart';
import 'package:nero_app/src/user/model/user_model.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  final ProductRepository _productRepository;

  ChatController(
    this._chatRepository,
    this._userRepository,
    this._productRepository,
  );

  late String ownerUid;
  late String customerUid;
  late String productId;
  late String myUid;

  Rx<Product> product = const Product.empty().obs;
  Rx<UserModel> opponentUser = const UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    ownerUid = Get.parameters['ownerUid'] as String;
    customerUid = Get.parameters['customerUid'] as String;
    productId = Get.parameters['docId'] as String;
    myUid = Get.find<AuthenticationController>().userModel.value.uid ?? '';
    _loadProductInfo();
    _loadOpponentUser(ownerUid == myUid ? customerUid : ownerUid);
  }

  _loadOpponentUser(String opponentUid) async {
    var userMode = await _userRepository.findUserOne(opponentUid);
    if (userMode != null) {
      opponentUser(userMode);
    }
  }

  Future<void> _loadProductInfo() async {
    var result = await _productRepository.getProduct(productId);
    if (result != null) {
      product(result);
    }
  }
}
