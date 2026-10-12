import 'package:flutter/material.dart';

import 'detailgadget.dart';
import 'gadget.dart';

class CatalogPage extends StatelessWidget {
  final String username;

  const CatalogPage({super.key, this.username = ''});

  // Data contoh, silakan ganti sesuai produkmu
  static const List<Gadget> _items = [
    Gadget(icon: Icons.smartphone_rounded, nama: "Smartphone", color: Colors.indigo, harga: 3500000),
    Gadget(icon: Icons.laptop_mac_rounded, nama: "Laptop", color: Colors.teal, harga: 12500000),
    Gadget(icon: Icons.tablet_mac_rounded, nama: "Tablet", color: Colors.deepPurple, harga: 4800000),
    Gadget(icon: Icons.watch_rounded, nama: "Smartwatch", color: Colors.orange, harga: 1900000),
    Gadget(icon: Icons.headphones_rounded, nama: "Headphone", color: Colors.pink, harga: 750000),
    Gadget(icon: Icons.keyboard_rounded, nama: "Keyboard", color: Colors.blueGrey, harga: 450000),
    Gadget(icon: Icons.mouse_rounded, nama: "Mouse", color: Colors.green, harga: 250000),
    Gadget(icon: Icons.speaker_rounded, nama: "Speaker", color: Colors.deepOrange, harga: 600000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Banner sapaan
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username.isEmpty ? "Halo!" : "Halo, $username!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Temukan gadget favoritmu hari ini",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.shopping_bag_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Semua Gadget",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (final item in _items) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(item: item),
                    ),
                  );
                },
                child: _GadgetCard(item: item),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _GadgetCard extends StatelessWidget {
  final Gadget item;

  const _GadgetCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris 1: [icon] Gadget [NAMA]
          Row(
            children: [
              Hero(
                tag: 'icon_${item.nama}',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [item.color, item.color.withAlpha(150)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withAlpha(90),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(item.icon, size: 28, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Gadget ${item.nama}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          // Baris 2: Rp[HARGA]
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.color.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.hargaText,
              style: TextStyle(
                fontSize: 16,
                color: item.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}