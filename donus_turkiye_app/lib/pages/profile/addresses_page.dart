// lib/pages/profile/addresses_page.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class AddressesPage extends StatefulWidget {
  final UserModel user;

  const AddressesPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  // Kullanıcının adres listesi
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': '1',
      'title': 'Ev',
      'icon': Icons.home,
      'address': 'Aziziye Mah. Atatürk Cad. No:15 Düzce',
      'details': 'Kat: 3, Daire: 7',
      'note': 'Taksi durağının karşısında',
      'isDefault': true,
    },
    {
      'id': '2',
      'title': 'İş',
      'icon': Icons.work,
      'address': 'Cedidiye Mah. İstanbul Cad. No:42 Düzce',
      'details': 'Kat: 2, Ofis: 5',
      'note': 'Mavi plazanın içinde',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adreslerim'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Adres Listesi
          Expanded(
            child: _addresses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final address = _addresses[index];
                      return _buildAddressCard(address, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAddressBottomSheet();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Boş adres listesi durumu
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 72,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz kayıtlı adresiniz yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni adres eklemek için + butonuna tıklayın',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Adres kartı
  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          // Adres Başlık Kısmı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    address['icon'],
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  address['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (address['isDefault'])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Varsayılan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditAddressBottomSheet(address, index);
                    } else if (value == 'delete') {
                      _showDeleteAddressDialog(index);
                    } else if (value == 'default') {
                      _setAsDefault(index);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!address['isDefault'])
                      const PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 8),
                            Text('Varsayılan Yap'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 8),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Adres İçerik Kısmı
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address['address'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                if (address['details'] != null && address['details'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 28),
                    child: Text(
                      address['details'],
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                if (address['note'] != null && address['note'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address['note'],
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Adres türü butonu
  Widget _buildAddressTypeButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.green[600] : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.green[600] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Yeni adres ekleme bottom sheet
  void _showAddAddressBottomSheet() {
    final titleController = TextEditingController(text: 'Ev');
    final addressController = TextEditingController();
    final detailsController = TextEditingController();
    final noteController = TextEditingController();
    IconData selectedIcon = Icons.home;
    String selectedTitle = 'Ev';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Başlık ve Kapat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Yeni Adres Ekle',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),

                  // İçerik
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Adres türü seçimi
                          const Text(
                            'Adres Türü',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildAddressTypeButton(
                                title: 'Ev',
                                icon: Icons.home,
                                isSelected: selectedTitle == 'Ev',
                                onTap: () {
                                  setState(() {
                                    selectedTitle = 'Ev';
                                    selectedIcon = Icons.home;
                                    titleController.text = selectedTitle;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAddressTypeButton(
                                title: 'İş',
                                icon: Icons.work,
                                isSelected: selectedTitle == 'İş',
                                onTap: () {
                                  setState(() {
                                    selectedTitle = 'İş';
                                    selectedIcon = Icons.work;
                                    titleController.text = selectedTitle;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAddressTypeButton(
                                title: 'Diğer',
                                icon: Icons.location_on,
                                isSelected: selectedTitle == 'Diğer',
                                onTap: () {
                                  setState(() {
                                    selectedTitle = 'Diğer';
                                    selectedIcon = Icons.location_on;
                                    titleController.text = 'Diğer';
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Harita
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.map,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Haritadan Seç'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Form alanları
                          const Text(
                            'Adres Bilgileri',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Adres Başlığı',
                              prefixIcon: Icon(selectedIcon),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: addressController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Adres',
                              prefixIcon:
                                  const Icon(Icons.location_on_outlined),
                              hintText: 'Mahalle, Cadde, Sokak, Numara',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: detailsController,
                            decoration: InputDecoration(
                              labelText: 'Kat, Daire, Bina, vs.',
                              prefixIcon: const Icon(Icons.apartment),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: noteController,
                            decoration: InputDecoration(
                              labelText: 'Not',
                              prefixIcon: const Icon(Icons.note),
                              hintText: 'Ör: Taksi durağının karşısı',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Kaydet butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Adres ekleme işlemi
                        if (addressController.text.isNotEmpty) {
                          setState(() {
                            _addresses.add({
                              'id': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'title': titleController.text,
                              'icon': selectedIcon,
                              'address': addressController.text,
                              'details': detailsController.text,
                              'note': noteController.text,
                              'isDefault': _addresses.isEmpty ? true : false,
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Adres başarıyla eklendi'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lütfen adres bilgisini giriniz'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'KAYDET',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  // Adres düzenleme bottom sheet
  void _showEditAddressBottomSheet(Map<String, dynamic> address, int index) {
    final titleController = TextEditingController(text: address['title']);
    final addressController = TextEditingController(text: address['address']);
    final detailsController = TextEditingController(text: address['details']);
    final noteController = TextEditingController(text: address['note']);
    IconData selectedIcon = address['icon'];
    String selectedTitle = address['title'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Başlık ve Kapat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Adresi Düzenle',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),

                  // İçerik
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Adres türü seçimi
                          const Text(
                            'Adres Türü',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildAddressTypeButton(
                                title: 'Ev',
                                icon: Icons.home,
                                isSelected: selectedTitle == 'Ev',
                                onTap: () {
                                  setState(() {
                                    selectedTitle = 'Ev';
                                    selectedIcon = Icons.home;
                                    titleController.text = selectedTitle;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAddressTypeButton(
                                title: 'İş',
                                icon: Icons.work,
                                isSelected: selectedTitle == 'İş',
                                onTap: () {
                                  setState(() {
                                    selectedTitle = 'İş';
                                    selectedIcon = Icons.work;
                                    titleController.text = selectedTitle;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAddressTypeButton(
                                title: 'Diğer',
                                icon: Icons.location_on,
                                isSelected: selectedTitle == 'Diğer',
                                onTap: () {
                                  setState(() {
                                    selectedTitle = 'Diğer';
                                    selectedIcon = Icons.location_on;
                                    titleController.text = 'Diğer';
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Harita
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.map,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Haritadan Seç'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Form alanları
                          const Text(
                            'Adres Bilgileri',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Adres Başlığı',
                              prefixIcon: Icon(selectedIcon),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: addressController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Adres',
                              prefixIcon:
                                  const Icon(Icons.location_on_outlined),
                              hintText: 'Mahalle, Cadde, Sokak, Numara',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: detailsController,
                            decoration: InputDecoration(
                              labelText: 'Kat, Daire, Bina, vs.',
                              prefixIcon: const Icon(Icons.apartment),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: noteController,
                            decoration: InputDecoration(
                              labelText: 'Not',
                              prefixIcon: const Icon(Icons.note),
                              hintText: 'Ör: Taksi durağının karşısı',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Güncelle butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Adres güncelleme işlemi
                        if (addressController.text.isNotEmpty) {
                          setState(() {
                            _addresses[index] = {
                              'id': address['id'],
                              'title': titleController.text,
                              'icon': selectedIcon,
                              'address': addressController.text,
                              'details': detailsController.text,
                              'note': noteController.text,
                              'isDefault': address['isDefault'],
                            };
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Adres başarıyla güncellendi'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lütfen adres bilgisini giriniz'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'GÜNCELLE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  // Adres silme diyaloğu
  void _showDeleteAddressDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adres Sil'),
        content: const Text('Bu adresi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İPTAL'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Eğer varsayılan adres siliniyorsa ve başka adres varsa, ilk adresi varsayılan yap
                if (_addresses[index]['isDefault'] && _addresses.length > 1) {
                  for (int i = 0; i < _addresses.length; i++) {
                    if (i != index) {
                      _addresses[i]['isDefault'] = true;
                      break;
                    }
                  }
                }
                _addresses.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adres silindi'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('SİL'),
          ),
        ],
      ),
    );
  }

  // Varsayılan adres ayarlama
  void _setAsDefault(int index) {
    setState(() {
      for (var address in _addresses) {
        address['isDefault'] = false;
      }
      _addresses[index]['isDefault'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Varsayılan adres güncellendi'),
      ),
    );
  }
}
