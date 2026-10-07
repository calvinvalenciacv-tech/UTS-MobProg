import 'package:flutter/material.dart';
import 'main.dart';

class DetailMenuPage extends StatefulWidget {
  final Menu menu;
  const DetailMenuPage({super.key, required this.menu});

  @override
  State<DetailMenuPage> createState() => _DetailMenuPageState();
}

class _DetailMenuPageState extends State<DetailMenuPage> {
  int qty = 1;
  final TextEditingController catatanCtrl = TextEditingController();

  late final Map<String, List<String>> opsi;
  late final Map<String, int> terpilih;

  @override
  void initState() {
    super.initState();
    if (widget.menu.kategori == 'Minuman') {
      opsi = {
        'Level Gula': ['Less Sugar', 'Normal', 'Extra Sugar'],
        'Es Batu': ['Tanpa Es', 'Normal', 'Banyak Es'],
      };
    } else {
      opsi = {
        'Tingkat Kepedasan': ['Tidak Pedas', 'Sedang', 'Pedas', 'Extra Pedas'],
        'Pilihan Nasi': ['Tanpa Nasi', 'Nasi Putih', 'Nasi Uduk'],
      };
    }
    terpilih = {for (final k in opsi.keys) k: 1};
  }

  @override
  void dispose() {
    catatanCtrl.dispose();
    super.dispose();
  }

  String get ringkasanOpsi =>
      opsi.entries.map((e) => e.value[terpilih[e.key]!]).join(', ');

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: kPrimary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: FotoNetwork(menu.foto, width: double.infinity),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menu.nama,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(rupiah(menu.harga),
                      style: const TextStyle(
                          fontSize: 20, color: kAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(menu.deskripsi,
                      style: const TextStyle(color: Colors.black87, height: 1.4)),
                  const Divider(height: 32),

                  ...opsi.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.key,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(e.value.length, (i) {
                            return ChoiceChip(
                              label: Text(e.value[i]),
                              selected: terpilih[e.key] == i,
                              selectedColor: kPrimary.withOpacity(0.15),
                              onSelected: (_) =>
                                  setState(() => terpilih[e.key] = i),
                            );
                          }),
                        ),
                      ],
                    ),
                  )),

                  const Text('Catatan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: catatanCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Contoh: sambal dipisah, jangan pakai bawang...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: qty > 1 ? () => setState(() => qty--) : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$qty',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(
                      onPressed: () => setState(() => qty++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    cart.tambah(menu, ringkasanOpsi, catatanCtrl.text.trim(), qty);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${menu.nama} ditambahkan ke keranjang')),
                    );
                  },
                  child: Text('Tambah • ${rupiah(menu.harga * qty)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}