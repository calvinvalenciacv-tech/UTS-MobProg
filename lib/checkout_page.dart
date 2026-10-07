import 'package:flutter/material.dart';
import 'main.dart';
import 'keranjang_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const List<(IconData, String)> metode = [
    (Icons.qr_code_2, 'QRIS'),
    (Icons.account_balance, 'Transfer Bank'),
    (Icons.account_balance_wallet, 'E-Wallet (OVO / GoPay / DANA)'),
    (Icons.payments_outlined, 'Bayar di Tempat (COD)'),
  ];
  int pilihan = 0;

  final _formKey = GlobalKey<FormState>();
  final namaCtrl = TextEditingController();
  final hpCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();

  @override
  void dispose() {
    namaCtrl.dispose();
    hpCtrl.dispose();
    alamatCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dekor(String label, IconData ikon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(ikon, color: kAccent),
      filled: true,
      fillColor: kBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _bayar(int total) {
    if (!_formKey.currentState!.validate()) return;

    final dibayarDengan = metode[pilihan].$2;
    final nama = namaCtrl.text.trim();
    final alamat = alamatCtrl.text.trim();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 56),
        title: const Text('Pesanan Berhasil!'),
        content: Text(
            'Terima kasih, $nama!\n\nPembayaran ${rupiah(total)} via $dibayarDengan.\n'
                'Pesanan dikirim ke:\n$alamat\n\nPesananmu sedang diproses.'),
        actions: [
          TextButton(
            onPressed: () {
              cart.kosongkan();
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = cart.subtotal + kOngkir;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _KartuSeksi(
            judul: 'Alamat Pengiriman',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: namaCtrl,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _dekor('Nama Penerima', Icons.person_outline),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: hpCtrl,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: _dekor('Nomor HP', Icons.phone_outlined,
                        hint: '0812xxxxxxxx'),
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Nomor HP wajib diisi';
                      if (s.length < 9) return 'Nomor HP terlalu pendek';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: alamatCtrl,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _dekor('Alamat Lengkap', Icons.location_on,
                        hint: 'Jalan, nomor rumah, RT/RW, kelurahan, kota'),
                    validator: (v) => (v == null || v.trim().length < 10)
                        ? 'Alamat wajib diisi (minimal 10 karakter)'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          _KartuSeksi(
            judul: 'Ringkasan Pesanan',
            child: Column(
              children: [
                ...cart.items.map((it) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: BarisHarga('${it.qty}x ${it.menu.nama}', rupiah(it.total)),
                )),
                const Divider(height: 24),
                BarisHarga('Subtotal', rupiah(cart.subtotal)),
                const SizedBox(height: 6),
                BarisHarga('Ongkos Kirim', rupiah(kOngkir)),
                const Divider(height: 24),
                BarisHarga('Total Bayar', rupiah(total), tebal: true),
              ],
            ),
          ),
          _KartuSeksi(
            judul: 'Metode Pembayaran',
            child: Column(
              children: List.generate(metode.length, (i) {
                final aktif = pilihan == i;
                return GestureDetector(
                  onTap: () => setState(() => pilihan = i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: aktif ? kPrimary : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: aktif ? kPrimary.withOpacity(0.06) : null,
                    ),
                    child: ListTile(
                      leading: Icon(metode[i].$1, color: kPrimary),
                      title: Text(metode[i].$2),
                      trailing: Icon(
                        aktif ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: aktif ? kPrimary : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _bayar(total),
            child: Text('Bayar Sekarang • ${rupiah(total)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

class _KartuSeksi extends StatelessWidget {
  final String judul;
  final Widget child;
  const _KartuSeksi({required this.judul, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}