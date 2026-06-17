import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

import 'detail_screen.dart';
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

            return _buildSkeletonizer();
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonizer() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return ColoredBox(
      color: const Color(0xff130d0f),
      child: Skeletonizer(
        effect: _skeletonEffect(),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 1200 ? (screenWidth - 1200) / 2 : 8,
            vertical: 8,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 20,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isGridView ? (isLandscape ? 4 : 2) : 1,
            childAspectRatio: _isGridView ? 3 / 5 : 4 / 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            if (_isGridView) {
              return const _SkeletonProductCard();
            }

            return const _SkeletonListTile();
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

  static ShimmerEffect _skeletonEffect() {
    return const ShimmerEffect(
      baseColor: Color(0xff333333),
      highlightColor: Color(0xff4a4a4a),
      duration: Duration(milliseconds: 1200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
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
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => DetailScreen(item: item)));
      },
      child: DecoratedBox(
        decoration: _FirstScreenState._cardDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _FirstScreenState._buildCardContent(item),
        ),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({required this.item});

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => DetailScreen(item: item)));
      },
      child: Container(
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
      ),
    );
  }
}

class _SkeletonProductCard extends StatelessWidget {
  const _SkeletonProductCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xff211719),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Bone(
                width: double.infinity,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
            SizedBox(height: 12),
            Bone(
              height: 8,
              width: double.infinity,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            SizedBox(height: 14),
            Bone(
              height: 8,
              width: 104,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonListTile extends StatelessWidget {
  const _SkeletonListTile();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xff211719),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: const SizedBox(
        height: 132,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Bone.square(
                size: 116,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Bone(
                      height: 8,
                      width: double.infinity,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 14),
                    Bone(
                      height: 8,
                      width: 120,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 14),
                    Bone(
                      height: 8,
                      width: double.infinity,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
