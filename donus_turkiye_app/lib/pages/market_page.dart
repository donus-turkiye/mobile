// lib/pages/market_page.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';

class MarketPage extends StatefulWidget {
  final UserModel user;

  const MarketPage({super.key, required this.user});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  String _selectedCategory = 'Tümü';
  final List<String> _categories = [
    'Tümü',
    'Kağıt',
    'Plastik',
    'Cam',
    'Elektronik'
  ];

  // Sepet verileri
  final List<CartItem> _cartItems = [];
  double _totalCartPoints = 0;

  // Örnek ürünler - Gerçek uygulamada veri tabanından çekilecek
  late List<ProductModel> _products;

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  void _initializeProducts() {
    _products = [
      ProductModel(
        id: '1',
        name: 'Geri Dönüşümlü Defter',
        description:
            '%100 geri dönüştürülmüş kağıttan yapılmış, 80 sayfalı çizgili defter.',
        price: 15.0,
        imageUrl: 'assets/images/recycled_notebook.jpg',
        category: 'Kağıt',
      ),
      ProductModel(
        id: '2',
        name: 'Bambu Diş Fırçası',
        description:
            'Doğada çözünebilen bambudan yapılmış çevre dostu diş fırçası.',
        price: 12.5,
        imageUrl: 'assets/images/bamboo_toothbrush.jpg',
        category: 'Plastik',
      ),
      ProductModel(
        id: '3',
        name: 'Geri Dönüşümlü Bardak Seti',
        description: 'Geri dönüştürülmüş camdan üretilmiş 4 adet bardak seti.',
        price: 35.0,
        imageUrl: 'assets/images/recycled_glass.jpg',
        category: 'Cam',
      ),
      ProductModel(
        id: '4',
        name: 'Güneş Enerjili Şarj Cihazı',
        description: 'Güneş enerjisiyle çalışan taşınabilir şarj cihazı.',
        price: 85.0,
        imageUrl: 'assets/images/solar_charger.jpg',
        category: 'Elektronik',
      ),
      ProductModel(
        id: '5',
        name: 'Bez Çanta',
        description: 'Geri dönüştürülmüş kumaştan yapılmış alışveriş çantası.',
        price: 20.0,
        imageUrl: 'assets/images/fabric_bag.jpg',
        category: 'Plastik',
      ),
      ProductModel(
        id: '6',
        name: 'Kompost Kiti',
        description:
            'Evde organik atıklarınızı kompost yapmak için başlangıç kiti.',
        price: 50.0,
        imageUrl: 'assets/images/compost_kit.jpg',
        category: 'Tümü',
      ),
    ];
  }

  // Filtrelenmiş ürünleri getir
  List<ProductModel> get _filteredProducts {
    if (_selectedCategory == 'Tümü') {
      return _products;
    }
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  // Sepete ürün ekleme fonksiyonu
  void _addToCart(ProductModel product) {
    setState(() {
      // Sepette aynı üründen varsa miktarını artır
      int existingIndex =
          _cartItems.indexWhere((item) => item.product.id == product.id);

      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(product: product, quantity: 1));
      }

      // Toplam sepet tutarını güncelle
      _calculateTotal();
    });

    // Bildirim göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF8BC399),
      ),
    );
  }

  // Sepetten ürün çıkarma fonksiyonu
  void _removeFromCart(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        // Miktar 1'den fazlaysa azalt
        int index = _cartItems
            .indexWhere((cartItem) => cartItem.product.id == item.product.id);
        _cartItems[index].quantity--;
      } else {
        // Miktar 1 ise ürünü tamamen çıkar
        _cartItems
            .removeWhere((cartItem) => cartItem.product.id == item.product.id);
      }

      // Toplam sepet tutarını güncelle
      _calculateTotal();
    });
  }

  // Toplam sepet tutarını hesapla
  void _calculateTotal() {
    _totalCartPoints = 0;
    for (var item in _cartItems) {
      _totalCartPoints += (item.product.price * item.quantity);
    }
  }

  // Satın alma işlemi
  void _checkout() {
    if (_cartItems.isEmpty) {
      // Sepet boşsa uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sepetiniz boş!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_totalCartPoints > widget.user.walletBalance) {
      // Bakiye yetersizse uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yetersiz bakiye!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Başarılı satın alma işlemi (Gerçek uygulamada bakiye düşürülecek)
    // Burada backend servisi çağrılacak

    // UI güncelleme
    setState(() {
      _cartItems.clear();
      _totalCartPoints = 0;
    });

    // Başarılı mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Satın alma işlemi başarılı!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );

    // Alışveriş tamamlandı diyalog penceresini göster
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Satın Alma Başarılı'),
          content: const Text(
              'Siparişiniz alındı. Ürünleriniz en yakın geri dönüşüm merkezinden teslim alabilirsiniz.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Üst Bölüm: Kullanıcı Bilgileri ve Bakiye
            _buildHeader(),

            // Kategori Seçimi
            _buildCategorySelector(),

            // Ürün Listesi
            Expanded(
              child: _buildProductGrid(),
            ),
          ],
        ),
      ),
      // Sepet Butonu
      floatingActionButton: _buildCartButton(),
    );
  }

  // Üst Bölüm: Kullanıcı Bilgileri ve Bakiye
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Profil Resmi
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(widget.user.profileImageUrl),
          ),
          const SizedBox(width: 12),
          // Kullanıcı Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, ${widget.user.name}!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Çevre dostu ürünlerimizi keşfedin.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Bakiye Gösterimi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.eco,
                  color: Color(0xFF2E7D32),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.user.walletBalance.toStringAsFixed(1)} P',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kategori Seçim Bölümü
  Widget _buildCategorySelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          // Kategori için ikon seçimi
          IconData categoryIcon;
          switch (category) {
            case 'Kağıt':
              categoryIcon = Icons.article_outlined;
              break;
            case 'Plastik':
              categoryIcon = Icons.local_drink_outlined;
              break;
            case 'Cam':
              categoryIcon = Icons.wine_bar_outlined;
              break;
            case 'Elektronik':
              categoryIcon = Icons.devices_outlined;
              break;
            default:
              categoryIcon = Icons.category_outlined;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF8BC399) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF8BC399)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      categoryIcon,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Ürün Listesi Grid Görünümü
  Widget _buildProductGrid() {
    return _filteredProducts.isEmpty
        ? const Center(child: Text('Bu kategoride ürün bulunamadı.'))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return _buildProductCard(product);
            },
          );
  }

  // Ürün Kartı
  Widget _buildProductCard(ProductModel product) {
    bool canAfford = widget.user.walletBalance >= product.price;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ürün Resmi
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/placeholder.jpg', // Gerçek uygulamada product.imageUrl kullanılacak
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Geri dönüştürülmüş etiketi
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.recycling,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Geri Dönüşümlü',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ürün Bilgileri
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Fiyat
                    Row(
                      children: [
                        const Icon(
                          Icons.eco,
                          color: Color(0xFF2E7D32),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.price.toStringAsFixed(1)} P',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),

                    // Sepete Ekle Butonu
                    GestureDetector(
                      onTap: canAfford ? () => _addToCart(product) : null,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: canAfford
                              ? const Color(0xFF8BC399)
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: canAfford ? Colors.white : Colors.grey[600],
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sepet Butonu
  Widget _buildCartButton() {
    return Stack(
      children: [
        FloatingActionButton(
          onPressed: () {
            _showCartBottomSheet();
          },
          backgroundColor: const Color(0xFF2E7D32),
          child: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
        if (_cartItems.isNotEmpty)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                _cartItems.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // Sepet Bottom Sheet
  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sepetim',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sepet boşsa mesaj göster
                  if (_cartItems.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Sepetiniz boş',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.image),
                                // Gerçek uygulamada resim olacak
                                // backgroundImage: AssetImage(item.product.imageUrl),
                              ),
                              title: Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${item.product.price.toStringAsFixed(1)} P x ${item.quantity}',
                                style: const TextStyle(
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    color: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        _removeFromCart(item);
                                      });
                                    },
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: const Color(0xFF2E7D32),
                                    onPressed: () {
                                      setState(() {
                                        _addToCart(item.product);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Alt bilgi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Toplam
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Toplam:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.eco,
                                  color: Color(0xFF2E7D32),
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_totalCartPoints.toStringAsFixed(1)} P',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Satın Al Butonu
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _cartItems.isEmpty ||
                                      _totalCartPoints >
                                          widget.user.walletBalance
                                  ? Colors.grey
                                  : const Color(0xFF2E7D32),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _cartItems.isEmpty ||
                                    _totalCartPoints > widget.user.walletBalance
                                ? null
                                : () {
                                    Navigator.pop(context);
                                    _checkout();
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_bag_outlined),
                                const SizedBox(width: 8),
                                Text(
                                  _cartItems.isEmpty
                                      ? 'Sepet Boş'
                                      : _totalCartPoints >
                                              widget.user.walletBalance
                                          ? 'Yetersiz Bakiye'
                                          : 'Satın Al',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Sepet Item Model
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}
