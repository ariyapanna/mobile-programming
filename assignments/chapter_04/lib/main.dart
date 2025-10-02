import 'dart:convert';
import 'package:chapter_04/models/transaction.dart';
import 'package:chapter_04/providers/transaction_prodiver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: MaterialApp(
        title: 'Finance Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: Colors.amber)
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomePage(),
          '/add': (_) => const AddTransactionPage(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            onPressed: () => Provider.of<TransactionProvider>(context, listen: false).fetchTransactions(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, prov, _) {
          if (prov.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Saldo', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 6),
                            Text('Rp ${_calcBalance(prov.items)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filter belum diimplementasikan')));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.pie_chart_outline),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 90,
                child: GridView.count(
                  crossAxisCount: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: ['Food', 'Transport', 'Bills', 'Income'].map((cat) {
                    return GestureDetector(
                      onTap: () {

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Filter: $cat')));
                      },
                      child: Column(
                        children: [
                          CircleAvatar(child: Text(cat[0])),
                          const SizedBox(height: 6),
                          Text(cat, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              Expanded(
                child: prov.items.isEmpty
                    ? const Center(child: Text('Belum ada transaksi. Tekan + untuk menambah.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: prov.items.length,
                        itemBuilder: (context, idx) {
                          final tx = prov.items[idx];
                          return TransactionCard(tx: tx);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _calcBalance(List<TransactionItem> items) {
    double sum = 0.0;
    for (var e in items) {
      sum += e.isExpense ? -e.amount : e.amount;
    }
    return sum.toStringAsFixed(0);
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionItem tx;
  const TransactionCard({Key? key, required this.tx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TransactionDetailPage(tx: tx)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Icon / Image
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(radius: 26, backgroundColor: tx.isExpense ? Colors.red.shade50 : Colors.green.shade50),
                Icon(tx.isExpense ? Icons.arrow_upward : Icons.arrow_downward, color: tx.isExpense ? Colors.red : Colors.green),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${tx.category} • ${_formatDate(tx.date)}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text((tx.isExpense ? '-' : '+') + 'Rp ${tx.amount.toStringAsFixed(0)}', style: TextStyle(color: tx.isExpense ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _amount = '';
  String _category = 'Food';
  bool _isExpense = true;

  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul'),
                onSaved: (v) => _title = v?.trim() ?? '',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul tidak boleh kosong' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _amount = v?.trim() ?? '',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Jumlah tidak boleh kosong';
                  final parsed = double.tryParse(v.replaceAll(',', '.'));
                  if (parsed == null) return 'Masukkan angka yang valid';
                  if (parsed <= 0) return 'Jumlah harus lebih besar dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Tipe:'),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: _isExpense,
                    onSelected: (s) => setState(() => _isExpense = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: !_isExpense,
                    onSelected: (s) => setState(() => _isExpense = false),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: ['Food', 'Transport', 'Bills', 'Income', 'Misc'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v ?? 'Food'),
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();

    final parsed = double.parse(_amount.replaceAll(',', '.'));

    final newTx = TransactionItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _title,
      amount: parsed,
      category: _category,
      date: DateTime.now(),
      isExpense: _isExpense,
    );

    setState(() => _submitting = true);

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.addTransaction(newTx, syncToApi: true);

    setState(() => _submitting = false);

    Navigator.pop(context);
  }
}

class TransactionDetailPage extends StatelessWidget {
  final TransactionItem tx;
  const TransactionDetailPage({Key? key, required this.tx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tx.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Kategori: ${tx.category}'),
            const SizedBox(height: 8),
            Text('Jumlah: Rp ${tx.amount.toStringAsFixed(0)}', style: TextStyle(color: tx.isExpense ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Tanggal: ${tx.date.toLocal().toString()}'),
            const SizedBox(height: 16),
            const Text('JSON Representation:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
              child: Text(json.encode(tx.toJson())),
            ),
          ],
        ),
      ),
    );
  }
}
