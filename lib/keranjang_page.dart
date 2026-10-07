import 'package:flutter/material.dart';
import 'main.dart';
import 'checkout_page.dart';

class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Keranjang Pesanan')),
          body: cart.kosong ? _kosong(context) : _isi(),
          bottomNavigationBar: cart.kosong
              ? null
              : SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total', style: TextStyle(color: Colors.grey)),
                        Text(rupiah(cart.subtotal + kOngkir),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kPrimary)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutPage())),
                    child: const Text('Checkout',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _kosong(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text('Keranjang masih kosong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Yuk pilih menu seafood dulu!', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: const Text('Lihat Menu'),
          ),
        ],
      ),
    );
  }

  Widget _isi() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...cart.items.map((it) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              FotoNetwork(it.menu.foto,
                  width: 70, height: 70, radius: BorderRadius.circular(12)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(it.menu.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(it.opsi,
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    if (it.catatan.isNotEmpty)
                      Text('Catatan: ${it.catatan}',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic)),
                    const SizedBox(height: 6),
                    Text(rupiah(it.total),
                        style: const TextStyle(
                            color: kAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(children: [
                    _TombolQty(Icons.remove, () => cart.kurangQty(it)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${it.qty}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _TombolQty(Icons.add, () => cart.tambahQty(it)),
                  ]),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => cart.hapus(it),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 22),
                  ),
                ],
              ),
            ],
          ),
        )),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              BarisHarga('Subtotal', rupiah(cart.subtotal)),
              const SizedBox(height: 6),
              BarisHarga('Ongkos Kirim', rupiah(kOngkir)),
            ],
          ),
        ),
      ],
    );
  }
}

class _TombolQty extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _TombolQty(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16),
    ),
  );
}

class BarisHarga extends StatelessWidget {
  final String label, nilai;
  final bool tebal;
  const BarisHarga(this.label, this.nilai, {super.key, this.tebal = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: tebal ? FontWeight.bold : FontWeight.normal);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: style)),
        Text(nilai, style: style),
      ],
    );
  }
}