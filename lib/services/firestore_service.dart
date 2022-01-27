import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppinglist/models/app_user.dart';
import 'package:shoppinglist/models/shopping_item.dart';
import 'package:shoppinglist/services/auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static final CollectionReference<AppUser> _users =
      _instance.collection('users').withConverter(
            fromFirestore: (snapshot, _) =>
                AppUser.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (user, _) => user.toMap(),
          );

  static final CollectionReference<ShoppingItem> _shoppingLists =
      _instance.collection('shoppingLists').withConverter(
            fromFirestore: (snapshot, _) =>
                ShoppingItem.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (item, _) => item.toMap(),
          );

  static Future<void> addUser(AppUser user) => _users.doc(user.uid).set(user);
  static Future<DocumentSnapshot<AppUser>> getUser(String id) =>
      _users.doc(id).get();

  static addShoppingItem(String name) {
    var ref = _shoppingLists.doc();
    ref.set(
      ShoppingItem(
        isPurchased: false,
        itemId: ref.id,
        name: name,
        userId: AuthService.getUserId()!,
      ),
    );
  }

  static getShoppingItems(String uid) =>
      _shoppingLists.where('userId', isEqualTo: uid).snapshots();

  static Future<void> updateShoppingItem(String docId, bool value) async {
    return await _shoppingLists.doc(docId).update({
      'isPurchased': value,
    });
  }

  static removeShoppingItem(String itemId) async =>
      await _shoppingLists.doc(itemId).delete();
}
