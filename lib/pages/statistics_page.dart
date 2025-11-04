import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/bill.dart';
import '../services/hive_service.dart';

class StatisticsPage extends StatelessWidget {
  static const String routeName = '/stats';
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Bill>(HiveService.billsBoxName);
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Bill> b, _) {
          final all = b.values.toList();
          final total = all.length;
          final paid = all.where((e) => e.isPaid).length;
          final unpaid = total - paid;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatCard(title: 'Total Tagihan', value: '$total', color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                _StatCard(title: 'Sudah Dibayar', value: '$paid', color: Colors.green),
                const SizedBox(height: 12),
                _StatCard(title: 'Belum Dibayar', value: '$unpaid', color: Colors.red),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


