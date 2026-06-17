import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'product_model.dart';
import 'url_util.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.item});

  final ProductModel item;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _urlUtil = UrlUtil();

  Widget _buildSlideShow() {
    final images = widget.item.images;

    return CarouselSlider.builder(
      options: CarouselOptions(enlargeCenterPage: true, aspectRatio: 3 / 2),
      itemCount: images.length,
      itemBuilder: (context, index, viewIndex) {
        final pic = images[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: pic,
            placeholder: (_, _) => Container(color: Colors.grey),
            errorWidget: (_, _, _) => Container(color: Colors.grey.shade800),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: const Color(0xfffff7f9),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: const Text('Detail Screen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildSlideShow(),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(item.title),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      const url = 'https://www.alibaba.com/showroom/hat.html';
                      _urlUtil.open(url);
                    },
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: IconButton(
                  onPressed: () {
                    const url = 'tel:+85533123456';
                    _urlUtil.open(url);
                  },
                  tooltip: 'Call',
                  icon: const Icon(Icons.call),
                ),
              ),
            ],
          ),
          Card(child: ListTile(title: Text(item.description))),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: Text(item.price.toStringAsFixed(2)),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: IconButton(
                  onPressed: () {
                    const url =
                        'https://www.google.com/maps/place/ECCO+AEON+MALL+Mean+Chey/@11.4839809,104.919153,16z';
                    _urlUtil.open(url);
                  },
                  tooltip: 'Open map',
                  icon: const Icon(Icons.pin_drop),
                ),
              ),
            ],
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sell),
              title: Text(item.category.name),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 46,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xffad3f5e),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {},
              child: const Text('Add To Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
