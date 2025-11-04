import 'package:hive_flutter/hive_flutter.dart';
import '../model/bill.dart';

class HiveService {
  static const String billsBoxName = 'billsBox';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BillAdapter());
    }
    await Hive.openBox<Bill>(billsBoxName);
  }

  Box<Bill> get _box => Hive.box<Bill>(billsBoxName);

  List<Bill> getAllBills() => _box.values.toList();

  Future<int> addBill(Bill bill) async {
    return await _box.add(bill);
  }

  Future<void> updateBill(int key, Bill bill) async {
    await _box.put(key, bill);
  }

  Future<void> deleteBill(int key) async {
    await _box.delete(key);
  }

  int? keyOf(Bill bill) {
    return bill.key is int ? bill.key as int : null;
  }
}


