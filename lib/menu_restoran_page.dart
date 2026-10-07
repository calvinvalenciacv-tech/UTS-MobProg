import 'package:flutter/material.dart';
import 'main.dart';
import 'detail_menu_page.dart';
import 'keranjang_page.dart';

const List<Map<String, dynamic>> dataKategori = [
  {
    'name': 'Udang',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvwy56t5vNS10M89pjRL6O7gMhmPwO_f8YW_auQlNUzTT-Y59PVSEulUmx&s=10',
  },
  {
    'name': 'Kepiting',
    'image': 'https://media.istockphoto.com/id/472497550/id/foto/kepiting.jpg?s=612x612&w=0&k=20&c=QlnZBN4ImwFBPw1ADx4IEllsZBT9TI1Vc-7iDH-gZtU=',
  },
  {
    'name': 'Ikan',
    'image': 'https://images.alodokter.com/dk0z4ums3/image/upload/v1757480004/attached_image/ikan-belida-sumber-protein-air-tawar-yang-lezat-dan-kaya-manfaat.jpg',
  },
  {
    'name': 'Minuman',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSIDq2EcYpzbw6jcuueo1hkA6mzG3eP81zN2J6o2EPzGE7pPjJYC3yZYM&s=10',
  },
];

const List<Map<String, dynamic>> dataMenu = [
  {
    'name': 'Udang Saus Padang',
    'category': 'Udang',
    'price': 65000,
    'description': 'Udang segar dimasak dengan saus padang pedas manis yang gurih.',
    'image': 'https://awsimages.detik.net.id/community/media/visual/2023/05/08/resep-udang-saus-padang_43.jpeg?w=1200',
  },
  {
    'name': 'Udang Bakar Madu',
    'category': 'Udang',
    'price': 70000,
    'description': 'Udang bakar dengan olesan madu dan mentega, disajikan dengan sambal.',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQh8wOG7pRt5xMPBqsEkjAm3nQBZBOGgndsMwg9WLNOTQ&s=10',
  },
  {
    'name': 'Kepiting Saus Tiram',
    'category': 'Kepiting',
    'price': 120000,
    'description': 'Kepiting besar dengan saus tiram kental, daging tebal dan manis.',
    'image': 'https://assets.unileversolutions.com/recipes-v2/257818.jpg',
  },
  {
    'name': 'Kepiting Lada Hitam',
    'category': 'Kepiting',
    'price': 125000,
    'description': 'Kepiting dimasak dengan saus lada hitam pedas yang harum.',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbT2auDVw3gkgdxMHh5qfqBN3C23iI33uo80tShJ5-HaRhy87FvWN6rak&s=10',
  },
  {
    'name': 'Ikan Bakar Jimbaran',
    'category': 'Ikan',
    'price': 85000,
    'description': 'Ikan kakap bakar dengan bumbu Jimbaran dan sambal matah.',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7ia0Ts0dZbk73wOViICRCUzQTU2oSb55CHgENMQ4Nag&s=10',
  },
  {
    'name': 'Ikan Asam Manis',
    'category': 'Ikan',
    'price': 80000,
    'description': 'Ikan goreng crispy disiram saus asam manis dengan paprika dan nanas.',
    'image': 'https://akcdn.detik.net.id/visual/2022/11/24/1331034564_11.jpeg?w=720&q=90',
  },
  {
    'name': 'Es Teh Manis',
    'category': 'Minuman',
    'price': 8000,
    'description': 'Teh dingin segar dengan gula pilihan.',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnIvV-zSy-zY5FKY6sVtLTAd0NWuUgpPMhFAPciNjIUg&s=10',
  },
  {
    'name': 'Es Kelapa Muda',
    'category': 'Minuman',
    'price': 18000,
    'description': 'Kelapa muda segar dengan es serut.',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Es_Kelapa_Muda.JPG?utm_source=id.wikipedia.org&utm_campaign=index&utm_content=original',
  },
  {
    'name': 'Jus Jeruk',
    'category': 'Minuman',
    'price': 15000,
    'description': 'Jus jeruk peras asli tanpa pengawet.',
    'image': 'https://images.alodokter.com/dk0z4ums3/image/upload/v1699924261/attached_image/9-manfaat-jus-jeruk-yang-segarkan-harimu.jpg',
  },
];

final List<Kategori> daftarKategori = dataKategori.map(Kategori.fromMap).toList();
final List<Menu> daftarMenu = dataMenu.map(Menu.fromMap).toList();

class TombolKeranjang extends StatelessWidget {
  const TombolKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (_, __) => IconButton(
        icon: Badge(
          isLabelVisible: cart.jumlah > 0,
          label: Text('${cart.jumlah}'),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const KeranjangPage())),
      ),
    );
  }
}

class BarKeranjang extends StatelessWidget {
  const BarKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (_, __) {
        if (cart.kosong) return const SizedBox.shrink();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const KeranjangPage())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 8),
                    Text('${cart.jumlah} item • ${rupiah(cart.subtotal)}'),
                  ]),
                  const Text('Lihat Keranjang',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seafood Order', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [TombolKeranjang()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Mau makan apa hari ini?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Pilih kategori menu seafood kesukaanmu',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.9,
            children: daftarKategori.map((k) => _KategoriCard(k)).toList(),
          ),
        ],
      ),
      bottomNavigationBar: const BarKeranjang(),
    );
  }
}

class _KategoriCard extends StatelessWidget {
  final Kategori k;
  const _KategoriCard(this.k);

  @override
  Widget build(BuildContext context) {
    final jumlahMenu = daftarMenu.where((m) => m.kategori == k.nama).length;
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => MenuKategoriPage(kategori: k))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: FotoNetwork(k.foto,
                  width: double.infinity,
                  ikon: k.ikon,
                  radius: const BorderRadius.vertical(top: Radius.circular(18))),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(k.ikon, color: kAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(k.nama,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('$jumlahMenu menu',
                            style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuKategoriPage extends StatelessWidget {
  final Kategori kategori;
  const MenuKategoriPage({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    final items = daftarMenu.where((m) => m.kategori == kategori.nama).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(kategori.nama),
        actions: const [TombolKeranjang()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (_, i) => _MenuTile(items[i]),
      ),
      bottomNavigationBar: const BarKeranjang(),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final Menu m;
  const _MenuTile(this.m);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => DetailMenuPage(menu: m))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            FotoNetwork(m.foto, width: 90, height: 90, radius: BorderRadius.circular(12)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(m.deskripsi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(rupiah(m.harga),
                      style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}