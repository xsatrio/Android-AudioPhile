import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/artikel_model.dart';
import 'change_password_page.dart';
import 'detail_produk.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<ArtikelModel>> fetchArticles() async {
    final String response = await rootBundle.loadString('assets/artikel.json');
    return artikelModelFromJson(response);
  }

  Future<void> _retry() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AudioPhile',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.password),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<List<ArtikelModel>>(
        future: fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada artikel'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final artikel = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  height: 125,
                  child: Card(
                    child: Row(
                      children: [
                        FutureBuilder(
                          future: _loadImage(artikel.urlToImage),
                          builder: (context, imageSnapshot) {
                            if (imageSnapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(
                                width: 100,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (imageSnapshot.hasError) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: const SizedBox(
                                  width: 100,
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error),
                                      Text('Tap to Retry'),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: 100,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(artikel.urlToImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(artikel.title),
                            subtitle: Text(artikel.author),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(artikel.review),
                                const Icon(Icons.star, color: Colors.yellow),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailProdukPage(artikel: artikel),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
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
