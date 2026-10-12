import 'package:flutter/material.dart';

import 'gadget.dart';
import 'voucher.dart';

class DetailPage extends StatefulWidget {
  final Gadget item;

  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? _selectedVoucher;

  // Ambil angka persen dari teks voucher, contoh "Diskon 10%" -> 10
  int get _persen {
    final match = RegExp(r'(\d+)\s*%').firstMatch(_selectedVoucher ?? '');
    return match == null ? 0 : int.parse(match.group(1)!);
  }

  // Harga setelah diskon (sama dengan harga asli jika belum klaim voucher)
  int get _hargaAkhir {
    final harga = widget.item.harga;
    return harga - (harga * _persen ~/ 100);
  }

  Future<void> _klaimVoucher() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const VoucherPage()),
    );

    // result null jika user menekan back tanpa memilih
    if (result != null && mounted) {
      setState(() {
        _selectedVoucher = result;
      });
    }
  }

  Widget _infoRow(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final adaVoucher = _selectedVoucher != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Gadget")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // [Icon Produk]
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [item.color, item.color.withAlpha(150)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(32),
                        ),
                      ),
                      child: Center(
                        child: Hero(
                          tag: 'icon_${item.nama}',
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(item.icon, size: 90, color: item.color),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Kartu info produk
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
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
                        children: [
                          // Nama: Gadget [NAMA]
                          _infoRow(
                            "Nama:",
                            Text(
                              "Gadget ${item.nama}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          // Harga: Rp [HARGA] <- berubah setelah voucher diklaim
                          _infoRow(
                            "Harga:",
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (adaVoucher)
                                  Text(
                                    item.hargaText,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, anim) => FadeTransition(
                                    opacity: anim,
                                    child: ScaleTransition(scale: anim, child: child),
                                  ),
                                  child: Text(
                                    Gadget.formatRupiah(_hargaAkhir),
                                    key: ValueKey(_hargaAkhir),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: item.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          // Voucher: [Voucher Terpilih/-]
                          _infoRow(
                            "Voucher:",
                            Align(
                              alignment: Alignment.centerLeft,
                              child: adaVoucher
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withAlpha(30),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.local_offer_rounded,
                                            size: 16,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _selectedVoucher!,
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Text(
                                      "-",
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // [Klaim Voucher Diskon] <- await Navigator.push
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.color,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _klaimVoucher,
                  icon: const Icon(Icons.local_offer_rounded, color: Colors.white),
                  label: const Text(
                    "Klaim Voucher Diskon",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}