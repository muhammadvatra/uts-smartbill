import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/bill.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';
import 'add_bill_page.dart';
import 'statistics_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box<Bill> box = Hive.box<Bill>(HiveService.billsBoxName);

  Future<void> _togglePaid(int key, Bill bill) async {
    final updated = Bill(
      name: bill.name,
      amount: bill.amount,
      dueDateTime: bill.dueDateTime,
      isPaid: !bill.isPaid,
      notificationId: bill.notificationId,
    );
    await box.put(key, updated);

    if (updated.isPaid) {
      await NotificationService.instance.cancelNotification(updated.notificationId);
    } else if (updated.dueDateTime.isAfter(DateTime.now())) {
      await NotificationService.instance.scheduleNotification(
        id: updated.notificationId,
        title: 'Pengingat Tagihan: ${updated.name}',
        body: 'Jatuh tempo: ${DateFormat('dd MMM y HH:mm').format(updated.dueDateTime)}',
        scheduledDateTime: updated.dueDateTime,
      );
    }
  }

  Future<void> _deleteBill(int key, Bill bill) async {
    await NotificationService.instance.cancelNotification(bill.notificationId);
    await box.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartBill'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => Navigator.pushNamed(context, StatisticsPage.routeName),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Bill> b, _) {
          final entries = b.toMap().entries.toList()
            ..sort((a, c) => a.value.dueDateTime.compareTo(c.value.dueDateTime));
          if (entries.isEmpty) {
            return const Center(child: Text('Belum ada tagihan'));
          }
          return ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final e = entries[index];
              final bill = e.value;
              final key = e.key as int;
              final isOverdue = bill.dueDateTime.isBefore(DateTime.now()) && !bill.isPaid;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      bill.isPaid ? Colors.green : (isOverdue ? Colors.red : Theme.of(context).colorScheme.primary),
                  child: Icon(
                    bill.isPaid ? Icons.check_rounded : Icons.schedule_rounded,
                    color: Colors.white,
                  ),
                ),
                title: Text(bill.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(bill.amount)} • ${DateFormat('dd MMM y, HH:mm').format(bill.dueDateTime)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: () async {
                        await Navigator.pushNamed(context, AddBillPage.routeName,
                            arguments: {
                              'key': key,
                              'bill': bill,
                            });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () => _deleteBill(key, bill),
                    ),
                    Switch(
                      value: bill.isPaid,
                      onChanged: (_) => _togglePaid(key, bill),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddBillPage.routeName),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}


