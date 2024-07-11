import 'package:flutter/material.dart';
import '../models/artikel_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uas_pbp/helpers/notification_helper.dart';
import 'dart:async';

class DetailProdukPage extends StatelessWidget {
  final ArtikelModel artikel;
  final NotificationHelper notificationHelper = NotificationHelper();

  DetailProdukPage({required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              notificationHelper.showNotification(artikel.title, artikel.description);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _loadImage(artikel.urlToImage),
              builder: (context, imageSnapshot) {
                if (imageSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (imageSnapshot.hasError) {
                  return GestureDetector(
                    child: const Column(
                      children: [
                        Icon(Icons.error),
                        Text('Kembali & klik "retry" untuk memuat gambar'),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(artikel.urlToImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 8.0),
            const Divider(color: Colors.grey),
            Text(
              artikel.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Review : ${artikel.review}', style: const TextStyle(fontSize: 16)),
                const Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            Text('Toko : ${artikel.author}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8.0),
            const Divider(color: Colors.grey),
            Text(artikel.description, style: const TextStyle(fontSize: 16)),
            ElevatedButton(
              onPressed: () async {
                final url = artikel.url;
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  print('Could not launch $url');
                  throw 'Could not launch $url';
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                shadowColor: Colors.transparent,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Lihat Selengkapnya ...',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _loadImage(String url) async {
    final image = NetworkImage(url);
    final completer = Completer<void>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (info, call) => completer.complete(),
        onError: (error, stackTrace) => completer.completeError(error, stackTrace),
      ),
    );
    return completer.future;
  }
}
