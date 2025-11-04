import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../model/bill.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';

class AddBillPage extends StatefulWidget {
  static const String routeName = '/add';
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _dueDate;
  TimeOfDay? _reminderTime;

  int? editingKey;
  Bill? originalBill;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && originalBill == null) {
      editingKey = args['key'] as int?;
      originalBill = args['bill'] as Bill?;
      if (originalBill != null) {
        _nameController.text = originalBill!.name;
        _amountController.text = originalBill!.amount.toStringAsFixed(0);
        _dueDate = DateTime(
          originalBill!.dueDateTime.year,
          originalBill!.dueDateTime.month,
          originalBill!.dueDateTime.day,
        );
        _reminderTime = TimeOfDay(
          hour: originalBill!.dueDateTime.hour,
          minute: originalBill!.dueDateTime.minute,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _dueDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final initial = _reminderTime ?? TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) setState(() => _reminderTime = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null || _reminderTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal jatuh tempo dan waktu pengingat')),
      );
      return;
    }
    final dateTime = DateTime(
      _dueDate!.year,
      _dueDate!.month,
      _dueDate!.day,
      _reminderTime!.hour,
      _reminderTime!.minute,
    );

    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.replaceAll('.', '').replaceAll(',', '.')) ?? 0;

    final box = Hive.box<Bill>(HiveService.billsBoxName);
    if (editingKey != null && originalBill != null) {
      final updated = Bill(
        name: name,
        amount: amount,
        dueDateTime: dateTime,
        isPaid: originalBill!.isPaid,
        notificationId: originalBill!.notificationId,
      );
      await box.put(editingKey!, updated);
      await NotificationService.instance.cancelNotification(updated.notificationId);
      if (!updated.isPaid && dateTime.isAfter(DateTime.now())) {
        await NotificationService.instance.scheduleNotification(
          id: updated.notificationId,
          title: 'Pengingat Tagihan: $name',
          body: 'Jatuh tempo: ${DateFormat('dd MMM y HH:mm').format(dateTime)}',
          scheduledDateTime: dateTime,
        );
      }
    } else {
      final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(1000000000);
      final bill = Bill(
        name: name,
        amount: amount,
        dueDateTime: dateTime,
        isPaid: false,
        notificationId: notificationId,
      );
      await box.add(bill);
      if (dateTime.isAfter(DateTime.now())) {
        await NotificationService.instance.scheduleNotification(
          id: notificationId,
          title: 'Pengingat Tagihan: $name',
          body: 'Jatuh tempo: ${DateFormat('dd MMM y HH:mm').format(dateTime)}',
          scheduledDateTime: dateTime,
        );
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editingKey != null ? 'Edit Tagihan' : 'Tambah Tagihan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama tagihan'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah tagihan (Rp)'),
                validator: (v) => (double.tryParse(v?.replaceAll('.', '').replaceAll(',', '.') ?? '') == null)
                    ? 'Masukkan angka yang valid'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.event_rounded),
                      label: Text(
                        _dueDate == null
                            ? 'Tanggal jatuh tempo'
                            : DateFormat('dd MMM y').format(_dueDate!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.access_time_rounded),
                      label: Text(
                        _reminderTime == null
                            ? 'Waktu pengingat'
                            : _reminderTime!.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


