import 'package:flutter/material.dart';
import 'menu_restoran_page.dart';

const Color kPrimary = Color(0xFF0E6BA8);
const Color kAccent = Color(0xFFFF7A45);
const Color kBg = Color(0xFFF4F8FB);
const int kOngkir = 10000;

void main() => runApp(const SeafoodApp());

class SeafoodApp extends StatelessWidget {
  const SeafoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seafood Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: kBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class Menu {
  final String nama, kategori, deskripsi, foto;
  final int harga;
  const Menu(this.nama, this.kategori, this.harga, this.deskripsi, this.foto);

  factory Menu.fromMap(Map<String, dynamic> m) => Menu(
    m['name'] as String,
    m['category'] as String,
    m['price'] as int,
    m['description'] as String,
    m['image'] as String,
  );
}

class Kategori {
  final String nama, foto;
  final IconData ikon;
  const Kategori(this.nama, this.ikon, this.foto);

  factory Kategori.fromMap(Map<String, dynamic> m) {
    const ikonMap = {
      'Udang': Icons.set_meal,
      'Kepiting': Icons.pest_control,
      'Ikan': Icons.phishing,
      'Minuman': Icons.local_drink,
    };
    return Kategori(
        m['name'] as String, ikonMap[m['name']] ?? Icons.restaurant, m['image'] as String);
  }
}

class CartItem {
  final Menu menu;
  final String opsi;
  final String catatan;
  int qty;
  CartItem(this.menu, this.opsi, this.catatan, this.qty);
  int get total => menu.harga * qty;
}

class Cart extends ChangeNotifier {
  final List<CartItem> items = [];

  int get jumlah => items.fold(0, (t, e) => t + e.qty);
  int get subtotal => items.fold(0, (t, e) => t + e.total);
  bool get kosong => items.isEmpty;

  void tambah(Menu m, String opsi, String catatan, int qty) {
    for (final it in items) {
      if (it.menu == m && it.opsi == opsi && it.catatan == catatan) {
        it.qty += qty;
        notifyListeners();
        return;
      }
    }
    items.add(CartItem(m, opsi, catatan, qty));
    notifyListeners();
  }

  void tambahQty(CartItem it) {
    it.qty++;
    notifyListeners();
  }

  void kurangQty(CartItem it) {
    if (it.qty > 1) {
      it.qty--;
    } else {
      items.remove(it);
    }
    notifyListeners();
  }

  void hapus(CartItem it) {
    items.remove(it);
    notifyListeners();
  }

  void kosongkan() {
    items.clear();
    notifyListeners();
  }
}

final Cart cart = Cart();

String rupiah(int angka) {
  final s = angka.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp ${buf.toString()}';
}

class FotoNetwork extends StatelessWidget {
  final String url;
  final double? width, height;
  final BorderRadius radius;
  final IconData ikon;
  const FotoNetwork(this.url,
      {super.key,
        this.width,
        this.height,
        this.radius = BorderRadius.zero,
        this.ikon = Icons.set_meal});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: Colors.blue.shade50,
          child: Icon(ikon, color: Colors.blue.shade200, size: 40),
        ),
      ),
    );
  }
}