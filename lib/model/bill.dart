import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Bill extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime dueDateTime;

  @HiveField(3)
  bool isPaid;

  @HiveField(4)
  int notificationId;

  Bill({
    required this.name,
    required this.amount,
    required this.dueDateTime,
    this.isPaid = false,
    required this.notificationId,
  });
}

class BillAdapter extends TypeAdapter<Bill> {
  @override
  final int typeId = 1;

  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Bill(
      name: fields[0] as String,
      amount: (fields[1] as num).toDouble(),
      dueDateTime: fields[2] as DateTime,
      isPaid: fields[3] as bool,
      notificationId: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.dueDateTime)
      ..writeByte(3)
      ..write(obj.isPaid)
      ..writeByte(4)
      ..write(obj.notificationId);
  }
}


