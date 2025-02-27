// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import '../widgets/waste_categories_widget.dart';
import '../models/waste_models.dart';
import '../models/user_model.dart';
import '../pages/collect_waste_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Örnek kullanıcı modeli
  late UserModel _currentUser;
  
  // Toplam toplanan atık ve değeri
  double _totalEarnings = 184.00;
  int _totalItems = 72;
  
  // Seçilen atık kategorileri
  final List<WasteCategory> _selectedCategories = [];
  
  // Kategoriler gösterilsin mi?
  bool _showAllCategories = false;
  
  // Kategoriye göre geri dönüşüm istatistikleri
  final Map<String, Map<String, dynamic>> _categoryStats = {
    'Kağıt Atıklar': {'items': 25, 'earnings': 78.50},
    'Metal Atıklar': {'items': 18, 'earnings': 65.20},
    'Plastik Atıklar': {'items': 20, 'earnings': 30.30},
    'Cam Atıklar': {'items': 9, 'earnings': 10.00},
    'Elektronik Atıklar': {'items': 0, 'earnings': 0.00},
    'Organik Atıklar': {'items': 0, 'earnings': 0.00},
    'Tekstil Atıkları': {'items': 0, 'earnings': 0.00},
    'Lastik ve Kauçuk': {'items': 0, 'earnings': 0.00},
    'Pil ve Batarya': {'items': 0, 'earnings': 0.00},
    'Ahşap Atıklar': {'items': 0, 'earnings': 0.00},
  };
  
  // Toplam seçilen kategoriler için hesaplama
  void _calculateSelectedStats() {
    if (_selectedCategories.isEmpty) {
      _displayedItems = _totalItems;
      _displayedEarnings = _totalEarnings;
      _currentCategory = 'Tüm Kategoriler';
    } else {
      int items = 0;
      double earnings = 0.0;
      
      for (var category in _selectedCategories) {
        if (_categoryStats.containsKey(category.name)) {
          items += _categoryStats[category.name]!['items'] as int;
          earnings += _categoryStats[category.name]!['earnings'] as double;
        }
      }
      
      _displayedItems = items;
      _displayedEarnings = earnings;
      
      if (_selectedCategories.length == 1) {
        _currentCategory = _selectedCategories.first.name;
      } else {
        _currentCategory = 'Seçilen Kategoriler';
      }
    }
  }
  
  // Şu anda görüntülenen kategori istatistikleri (varsayılan olarak toplam)
  int _displayedItems = 72;
  double _displayedEarnings = 184.00;
  String _currentCategory = 'Tüm Kategoriler';
  
  @override
  void initState() {
    super.initState();
    // Örnek bir kullanıcı oluşturalım
    _currentUser = UserModel(
      id: '1',
      name: 'Admin',
      email: 'admin@donus.com',
      profileImageUrl: 'https://picsum.photos/200',
      walletBalance: 25.75,
      totalRecycledItems: _totalItems,
      totalEarnings: _totalEarnings,
    );
    
    // Tüm kategorileri başlangıçta seçilmemiş hale getir
    for (var category in WasteCategoryManager.allCategories) {
      category.isSelected = false;
    }
  }

  // Saat dilimine göre selamlama metni oluşturan fonksiyon
  String _getGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return 'Günaydın!';
    } else if (hour >= 12 && hour < 18) {
      return 'İyi öğleden sonralar!';
    } else if (hour >= 18 && hour < 22) {
      return 'İyi akşamlar!';
    } else {
      return 'İyi geceler!';
    }
  }

  // Atık Topla sayfasına git
  void _navigateToCollectWaste({WasteCategory? initialCategory}) {
    // Hata oluşmaması için null kontrol ekledik
    if (initialCategory == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollectWastePage(user: _currentUser),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollectWastePage(
            user: _currentUser,
            initialCategory: initialCategory,
          ),
        ),
      );
    }
  }
  
  // Kategori seçildiğinde istatistikleri güncelle
  void _updateDisplayedStats(String categoryName) {
    setState(() {
      if (categoryName == 'Tüm Kategoriler') {
        _displayedItems = _totalItems;
        _displayedEarnings = _totalEarnings;
        _currentCategory = 'Tüm Kategoriler';
      } else if (_categoryStats.containsKey(categoryName)) {
        _calculateSelectedStats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_currentUser.name),
              accountEmail: Text(_currentUser.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_currentUser.profileImageUrl),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF8BC399),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.recycling),
              title: const Text('Geri Dönüşüm'),
              onTap: () {
                Navigator.pop(context);
                _navigateToCollectWaste();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Geçmiş'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Paneli'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış Yap'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(_currentUser.profileImageUrl),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              'Geri Dönüşüme Bugün Başla!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Toplam Toplanan Atık Kartı
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentCategory,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₺${_displayedEarnings.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Toplanan atık değeri',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_displayedItems parça',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Atık Kategorileri Başlığı
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Atık Kategorileri',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllCategories = !_showAllCategories;
                        });
                      },
                      child: Text(
                        _showAllCategories ? 'Kapat' : 'Tümünü Gör',
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Seçilebilir Ana Kategoriler - Üstteki sıra
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryItem(
                      WasteCategoryManager.allCategories.firstWhere((e) => e.name == 'Kağıt Atıklar'),
                    ),
                    _buildCategoryItem(
                      WasteCategoryManager.allCategories.firstWhere((e) => e.name == 'Plastik Atıklar'),
                    ),
                    _buildCategoryItem(
                      WasteCategoryManager.allCategories.firstWhere((e) => e.name == 'Cam Atıklar'),
                    ),
                    _buildCategoryItem(
                      WasteCategoryManager.allCategories.firstWhere((e) => e.name == 'Metal Atıklar'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tüm Kategoriler Grid - Yalnızca "Tümünü Gör" tıklandığında göster
                if (_showAllCategories)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: WasteCategoryManager.allCategories
                            .map((category) => _buildCategoryButton(
                                  category,
                                  category.isSelected,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Yakındaki Geri Dönüşüm Noktaları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Yakındaki Geri Dönüşüm Noktaları',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Tümünü Gör',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Geri dönüşüm noktaları listesi
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildBinStationItem('Merkez Atık Toplama', 'Aziziye Mahallesi, Düzce', '2.3 km');
                    } else if (index == 1) {
                      return _buildBinStationItem('Cedidiye Toplama Merkezi', 'Cedidiye Mahallesi, Düzce', '3.1 km');
                    } else {
                      return _buildBinStationItem('Camikebir Atık Noktası', 'Camikebir Mahallesi, Düzce', '4.2 km');
                    }
                  },
                ),
                
                // Alt kısımda Navigation Bar'ın gözükmesi için ekstra boşluk
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      // Navigation Bar kaldırıldı - MainNavigation içinde tanımlanacak
    );
  }

  // Atık kategorisi butonu oluştur (Seçilebilir)
  Widget _buildCategoryButton(WasteCategory category, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // Kategori seçimini değiştir
          category.isSelected = !category.isSelected;
          
          if (category.isSelected) {
            if (!_selectedCategories.contains(category)) {
              _selectedCategories.add(category);
            }
          } else {
            _selectedCategories.remove(category);
          }
          
          // Seçili kategoriler toplamını hesapla
          _calculateSelectedStats();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: category.isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[200],
        foregroundColor: category.isSelected ? Colors.green : Colors.grey[700],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: category.isSelected 
              ? const BorderSide(color: Colors.green, width: 1.5)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Icon(category.icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category.name,
              style: TextStyle(
                fontWeight: category.isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  // Atık kategori ikonu oluştur (Üst sıra için)
  Widget _buildCategoryItem(WasteCategory category) {
    final isSelected = category.isSelected;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          // Kategori seçimini değiştir
          category.isSelected = !isSelected;
          
          if (category.isSelected) {
            if (!_selectedCategories.contains(category)) {
              _selectedCategories.add(category);
            }
          } else {
            _selectedCategories.remove(category);
          }
          
          // Seçili kategoriler toplamını hesapla
          _calculateSelectedStats();
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: isSelected 
                  ? Border.all(color: Colors.green, width: 1.5) 
                  : Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: Icon(
              category.icon,
              color: isSelected ? Colors.green : Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  // Geri dönüşüm noktası kartını oluşturan fonksiyon
  Widget _buildBinStationItem(String name, String address, String distance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  distance,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}