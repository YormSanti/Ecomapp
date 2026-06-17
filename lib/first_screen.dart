import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product_model.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool _isGridView = true;

  Future<List<ProductModel>> _getApi() async {
    // Future<List<Map<String, dynamic>>> _getApi() async {
    try {
      const url = 'https://api.escuelajs.co/api/v1/products';
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        // List list = jsonDecode(res.body);
        // List<Map<String, dynamic>> jsonList = list
        //     .map((x) => x as Map<String, dynamic>)
        //     .toList();
        List<ProductModel> list = productModelFromJson(res.body);
        return list;
      } else {
        throw Exception('Error status code: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // late Future<List<Map<String, dynamic>>> _futureData = _getApi();
  late Future<List<ProductModel>> _futureData = _getApi();

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _getApi();
          });
        },
        color: Colors.purple,
        child: FutureBuilder<List<ProductModel>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Error: ${snapshot.error.toString()}!'),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _buildProductView(snapshot.data);
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductView(List<ProductModel>? items) {
    if (items == null || items.isEmpty) {
      return const Icon(Icons.list);
    }

    return _isGridView ? _buildGridView(items) : _buildListView(items);
  }

  Widget _buildGridView(List<ProductModel> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 230,
        mainAxisExtent: 236,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ProductCard(item: items[index]);
      },
    );
  }

  Widget _buildListView(List<ProductModel> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ProductListTile(item: items[index]);
      },
    );
  }

  void _toggleProductView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  Widget _productViewIcon() {
    return Icon(_isGridView ? Icons.list : Icons.grid_view_rounded);
  }

  String _productViewTooltip() {
    return _isGridView ? 'List view' : 'Grid view';
  }

  static String _imageUrl(ProductModel item) {
    return item.images.isNotEmpty ? item.images.first : '';
  }

  static String _priceText(ProductModel item) {
    return 'USD ${item.price.toStringAsFixed(2)}';
  }

  static Widget _imagePlaceholder(Color color) {
    return ColoredBox(color: color);
  }

  static Widget _imageError() {
    return ColoredBox(color: Colors.grey.shade500);
  }

  static Widget _productImage({
    required ProductModel item,
    required BoxFit fit,
    double? width,
    double? height,
    Color placeholderColor = const Color(0xffdedede),
  }) {
    return CachedNetworkImage(
      imageUrl: _imageUrl(item),
      placeholder: (_, _) => _imagePlaceholder(placeholderColor),
      errorWidget: (_, _, _) => _imageError(),
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget _productTitle(ProductModel item, {TextAlign? textAlign}) {
    return Text(
      item.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: const TextStyle(fontSize: 12),
    );
  }

  static Widget _productPrice(ProductModel item) {
    return Text(
      _priceText(item),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 12),
    );
  }

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: const Color(0xfffdf1f7),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xfff0dce8)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  static Widget _clipCardImage(Widget child) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: child,
    );
  }

  static Widget _buildCardContent(ProductModel item) {
    return Column(
      children: [
        _clipCardImage(
          SizedBox(
            height: 160,
            width: double.infinity,
            child: _productImage(item: item, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _productTitle(item, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 14),
        _productPrice(item),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 24,
        title: const Text('First Screen'),
        actions: [
          IconButton(
            onPressed: _toggleProductView,
            tooltip: _productViewTooltip(),
            icon: _productViewIcon(),
          ),
          IconButton(
            onPressed: widget.onToggleTheme,
            tooltip: widget.isDarkMode ? 'Light mode' : 'Dark mode',
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.item});

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _FirstScreenState._cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _FirstScreenState._buildCardContent(item),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({required this.item});

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _FirstScreenState._cardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(8),
            ),
            child: _FirstScreenState._productImage(
              item: item,
              fit: BoxFit.cover,
              width: 132,
              height: 132,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FirstScreenState._productTitle(item),
                  const SizedBox(height: 14),
                  _FirstScreenState._productPrice(item),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
