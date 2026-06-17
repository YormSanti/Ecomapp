import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'product_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.item});

  final ProductModel item;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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

  Widget _buildInfoTile({required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffffeef4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xfff3d8e3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.brown.shade700, size: 22),
          const SizedBox(width: 14),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final item = widget.item;

    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      children: [
        _buildSlideShow(),
        const SizedBox(height: 8),
        _buildInfoTile(
          icon: Icons.shopping_bag,
          child: Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xffffeef4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xfff3d8e3)),
          ),
          child: Text(
            item.description,
            style: const TextStyle(fontSize: 14, height: 1.35),
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoTile(
          icon: Icons.attach_money,
          child: Text(
            item.price.toStringAsFixed(2),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoTile(
          icon: Icons.sell,
          child: Text(item.category.name, style: const TextStyle(fontSize: 14)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff7f9),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: const Text('Detail Screen'),
      ),
      body: _buildBody(),
    );
  }
}
