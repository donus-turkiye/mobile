// lib/pages/waste/waste_pickup_page.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'dart:io';
import 'dart:math'; // min fonksiyonu için gerekli

// ImagePicker kütüphanesini projede kullanabilmek için pubspec.yaml'a eklemeniz gerekiyor:
// dependencies:
//   image_picker: ^0.8.7+5
import 'package:image_picker/image_picker.dart';

/// WastePickupPage, kullanıcıların evden atık toplama randevusu oluşturabildiği sayfadır.
/// Bu sayfa, atık seçimi, tarih seçimi, adres girişi ve onay adımlarını içerir.
class WastePickupPage extends StatefulWidget {
  final UserModel user;
  final Map<String, dynamic>? existingAppointment;
  final Function(Map<String, dynamic>) onSaveAppointment;

  const WastePickupPage({
    super.key, 
    required this.user,
    this.existingAppointment,
    required this.onSaveAppointment,
  });

  @override
  State<WastePickupPage> createState() => _WastePickupPageState();
}

class _WastePickupPageState extends State<WastePickupPage> {
  // Görünüm kontrolleri
  String _currentStep = 'waste_selection'; // waste_selection, date_selection, address, confirmation
  
  // Diğer kategorileri gösterme durumu
  bool _showMoreCategories = false; // Değişkeni tanımladık
  
  // Seçilen atıklar ve miktarları
  final Map<String, int> _selectedWasteAmounts = {};
  
  // Tüm atık tipleri
  final List<Map<String, dynamic>> _wasteTypes = [
    {'name': 'Plastik', 'icon': Icons.shopping_bag, 'unit': 'Kg'},
    {'name': 'Metal', 'icon': Icons.blur_circular, 'unit': 'Kg'},
    {'name': 'Alüminyum', 'icon': Icons.layers, 'unit': 'Kg'},
    {'name': 'Kağıt', 'icon': Icons.description, 'unit': 'Kg'},
    {'name': 'Cam', 'icon': Icons.local_drink, 'unit': 'Kg'},
    {'name': 'Elektronik', 'icon': Icons.devices, 'unit': 'Adet'},
    {'name': 'Tekstil', 'icon': Icons.checkroom, 'unit': 'Kg'},
    {'name': 'Pil', 'icon': Icons.battery_full, 'unit': 'Adet'},
  ];
  // Randevu için tarih/saat
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00';
  int _displayedMonth = DateTime.now().month;
  int _displayedYear = DateTime.now().year;

  // Zaman seçenekleri
  final List<String> _timeSlots = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00'
  ];

  // Not
  final TextEditingController _noteController = TextEditingController();

  // Fotoğraflar
  final List<File> _wastePhotos = [];

  // ImagePicker, kullanıcının kameradan veya galeriden fotoğraf seçmesini sağlayan Flutter paketi
  final ImagePicker _picker = ImagePicker();

  // Adres
  final TextEditingController _addressController = TextEditingController();
  String _selectedAddress = 'home'; // home veya custom
  final String _homeAddress = 'Aziziye Mah. Atatürk Cad. No:15 Düzce';

  @override
  void initState() {
    super.initState();

    // Eğer var olan bir randevu düzenleniyorsa, bilgileri doldur
    if (widget.existingAppointment != null) {
      _loadExistingAppointmentData();
    }
  }

  /// Mevcut randevu verisini form alanlarına doldur
  void _loadExistingAppointmentData() {
    final appointment = widget.existingAppointment!;

    // Atık tipi ve miktarlarını ayarla
    if (appointment.containsKey('wasteDetails')) {
      final wasteDetails = appointment['wasteDetails'] as List;
      for (var waste in wasteDetails) {
        _selectedWasteAmounts[waste['type']] = waste['amount'];
      }
    }

    // Tarih ve zamanı ayarla
    if (appointment.containsKey('date') && appointment.containsKey('time')) {
      final dateParts = appointment['date'].split(' ');
      if (dateParts.length >= 3) {
        final day = int.parse(dateParts[0]);
        final month = _getMonthNumber(dateParts[1]);
        final year = int.parse(dateParts[2]);

        _selectedDate = DateTime(year, month, day);
        _displayedMonth = month;
        _displayedYear = year;
        _selectedTime = appointment['time'];
      }
    }

    // Notu ayarla
    if (appointment.containsKey('note')) {
      _noteController.text = appointment['note'];
    }

    // Adresi ayarla
    if (appointment.containsKey('address')) {
      if (appointment['address'] == _homeAddress) {
        _selectedAddress = 'home';
      } else {
        _selectedAddress = 'custom';
        _addressController.text = appointment['address'];
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep != 'waste_selection') {
              setState(() {
                // Bir önceki adıma geri dön
                switch (_currentStep) {
                  case 'date_selection':
                    _currentStep = 'waste_selection';
                    break;
                  case 'address':
                    _currentStep = 'date_selection';
                    break;
                  case 'confirmation':
                    _currentStep = 'address';
                    break;
                }
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // İlerleme çubuğu
          _buildProgressBar(),

          // Ana içerik
          Expanded(
            child: _buildCurrentStep(),
          ),
        ],
      ),
    );
  }

  /// Adıma göre AppBar başlığını döndür
  String _getAppBarTitle() {
    switch (_currentStep) {
      case 'waste_selection':
        return 'Atık Seçimi';
      case 'date_selection':
        return 'Randevu Seçimi';
      case 'address':
        return 'Adres Bilgileri';
      case 'confirmation':
        return 'Onay';
      default:
        return 'Evden Atık Alma';
    }
  }

  /// İlerleme çubuğunu oluştur
  Widget _buildProgressBar() {
    int currentStepIndex;

    switch (_currentStep) {
      case 'waste_selection':
        currentStepIndex = 0;
        break;
      case 'date_selection':
        currentStepIndex = 1;
        break;
      case 'address':
        currentStepIndex = 2;
        break;
      case 'confirmation':
        currentStepIndex = 3;
        break;
      default:
        currentStepIndex = 0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: List.generate(4, (index) {
          bool isActive = index <= currentStepIndex;
          bool isCurrent = index == currentStepIndex;

          return Expanded(
            child: Row(
              children: [
                // Adım dairesi
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isActive ? const Color(0xFF8BC399) : Colors.grey[300],
                    border: isCurrent
                        ? Border.all(color: Colors.green[700]!, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      _getStepIcon(index),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                // İlerleme çizgisi
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isActive && index < currentStepIndex
                          ? const Color(0xFF8BC399)
                          : Colors.grey[300],
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Adım numarasına göre ikon döndür
  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.delete_outline;
      case 1:
        return Icons.event;
      case 2:
        return Icons.location_on;
      case 3:
        return Icons.check;
      default:
        return Icons.circle;
    }
  }

  /// Mevcut adıma göre içerik görünümünü oluştur
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 'waste_selection':
        return _buildWasteSelectionStep();
      case 'date_selection':
        return _buildDateSelectionStep();
      case 'address':
        return _buildAddressStep();
      case 'confirmation':
        return _buildConfirmationStep();
      default:
        return _buildWasteSelectionStep();
    }
  }

  // ADIM 1: Atık Seçimi
  // _buildWasteSelectionStep() fonksiyonu güncellendi
// _buildWasteSelectionStep() fonksiyonu tamamen yenilendi
// WastePickupPage içindeki _buildWasteSelectionStep metodunda değişiklik yapalım

Widget _buildWasteSelectionStep() {
  // İlk 3 kategori
  final topCategories = _wasteTypes.take(3).toList();
  // Kalan kategoriler
  final remainingCategories = _wasteTypes.skip(3).toList();
  
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atık Kategorileri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toplamak istediğiniz atık türlerini ve miktarlarını seçin',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          
          // İlk 3 kategori için sabit görünüm
          Column(
            children: topCategories.map((waste) {
              final wasteName = waste['name'];
              final amount = _selectedWasteAmounts[wasteName] ?? 1;
              
              return _buildWasteItem(
                name: wasteName,
                icon: waste['icon'],
                unit: waste['unit'],
                amount: amount,
                isSelected: _selectedWasteAmounts.containsKey(wasteName),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == 0) {
                      _selectedWasteAmounts.remove(wasteName);
                    } else {
                      _selectedWasteAmounts[wasteName] = newValue;
                    }
                  });
                },
              );
            }).toList(),
          ),
          
          // "Diğer Kategoriler" başlığı (diğer kategoriler varsa göster)
          if (remainingCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Diğer Kategoriler',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showMoreCategories = !_showMoreCategories;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          _showMoreCategories ? 'Gizle' : 'Göster',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          _showMoreCategories 
                            ? Icons.keyboard_arrow_up 
                            : Icons.keyboard_arrow_down,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // Kalan kategoriler (açılır-kapanır) - Düzeltme burada
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showMoreCategories && remainingCategories.isNotEmpty 
                ? (remainingCategories.length * 95.0) // Kategori yüksekliğini artırdık
                : 0,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // İç listeyi sabit yap, dış liste kaydırılabilir olsun
              padding: EdgeInsets.zero, // Ekstra padding kaldırıldı
              shrinkWrap: true,
              itemCount: remainingCategories.length,
              itemBuilder: (context, index) {
                final waste = remainingCategories[index];
                final wasteName = waste['name'];
                final amount = _selectedWasteAmounts[wasteName] ?? 1;
                
                return _buildWasteItem(
                  name: wasteName,
                  icon: waste['icon'],
                  unit: waste['unit'],
                  amount: amount,
                  isSelected: _selectedWasteAmounts.containsKey(wasteName),
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue == 0) {
                        _selectedWasteAmounts.remove(wasteName);
                      } else {
                        _selectedWasteAmounts[wasteName] = newValue;
                      }
                    });
                  },
                );
              },
            ),
          ),
          
          
          // Son kategori için ekstra boşluğu azaltalım veya kaldıralım
if (_showMoreCategories && remainingCategories.isNotEmpty)
  const SizedBox(height: 8), // 16'dan 8'e düşürdük

// Kategoriler ile fotoğraf bölümü arasındaki boşluğu azaltalım
const SizedBox(height: 16), // 24'ten 16'ya düşürdük
          
          
          // Fotoğraflar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fotoğraf',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Atıkların fotoğrafını çekin veya galeriden seçin',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    // Çekilen fotoğraflar
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _wastePhotos.length + 1,
                        itemBuilder: (context, index) {
                          // Fotoğraf ekleme butonu
                          if (index == _wastePhotos.length) {
                            return Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _showPhotoOptions,
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                              ),
                            );
                          }
                          
                          // Mevcut fotoğraflar
                          return Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(_wastePhotos[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                // Silme butonu
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _wastePhotos.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Not alanı
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Not',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Atıklarınız hakkında not ekleyin',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          
          const SizedBox(height: 36),
          
          // İleri butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedWasteAmounts.isNotEmpty
                ? () {
                    setState(() {
                      _currentStep = 'date_selection';
                    });
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                disabledBackgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'İLERİ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Ekran sonunda ekstra boşluk
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}

// Atık öğesi widget'ı - daha basit bir şekilde yeniden düzenlenmiş
Widget _buildWasteItem({
  required String name,
  required IconData icon,
  required String unit,
  required int amount,
  required bool isSelected,
  required Function(int) onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? const Color(0xFF8BC399) : Colors.grey[300]!,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // İkon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 16),
        
        // İsim
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        
        const Spacer(),
        
        // Miktar kontrolü - ekrandaki düğmelere daha benzer
        Row(
          children: [
            // Azalt
            Material(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: InkWell(
                onTap: isSelected && amount > 1 
                  ? () => onChanged(amount - 1) 
                  : null,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: const Icon(Icons.remove, size: 18),
                ),
              ),
            ),
            
            // Miktar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              constraints: const BoxConstraints(minWidth: 60),
              color: Colors.grey[200],
              height: 36,
              alignment: Alignment.center,
              child: Text(
                '$amount $unit',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Artır
            Material(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
              child: InkWell(
                onTap: isSelected
                  ? () => onChanged(amount + 1)
                  : () => onChanged(1),
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: const Icon(Icons.add, size: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  /// Fotoğraf seçme veya çekme modalını göster
  void _showPhotoOptions() {
    // Kameradan fotoğraf çekme veya galeriden seçme için alt menü
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Kameradan Çek'),
            onTap: () {
              Navigator.pop(context);
              _getImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galeriden Seç'),
            onTap: () {
              Navigator.pop(context);
              _getImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  /// Kamera veya galeriden fotoğraf seç
  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _wastePhotos.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      if (mounted) {
        // Burada mounted kontrolü eklendi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Fotoğraf seçme hatası: image_picker kütüphanesini yüklediğinizden emin olun'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } // ADIM 2: Tarih Seçimi

  Widget _buildDateSelectionStep() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Randevu Tarihi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Atıklarınızın alınmasını istediğiniz tarihi seçin',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Takvim widget'ı
            _buildCalendarPicker(),

            const SizedBox(height: 24),

            // Saat Seçimi
            const Text(
              'Randevu Saati',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Atıklarınızın alınmasını istediğiniz saati seçin',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((time) {
                final isSelected = time == _selectedTime;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF8BC399) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // İleri butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 'address';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'İLERİ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Takvim widget'ı
  Widget _buildCalendarPicker() {
    final now = DateTime.now();

    final firstDayOfMonth = DateTime(_displayedYear, _displayedMonth, 1);
    final daysInMonth = DateTime(_displayedYear, _displayedMonth + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Pazartesi, 7 = Pazar

    // Önceki ayın son günlerini de göstermek için
    final daysInPreviousMonth =
        DateTime(_displayedYear, _displayedMonth, 0).day;
    final previousMonthDays = firstWeekday - 1; // Pazartesi başlangıç için

    // Toplam hücre sayısı (6 satır x 7 gün)
    const totalCells = 42;

    // Randevu alınabilecek son gün (bugünden 14 gün sonra)
    final lastBookableDate = DateTime(now.year, now.month, now.day + 14);

    // Ay ve yıl metnini oluştur
    final monthYearText =
        '${_getMonthNameFull(_displayedMonth)} $_displayedYear';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ay ve Yıl başlığı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthYearText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  // Önceki ay
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left,
                        color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (_displayedMonth > 1) {
                          _displayedMonth--;
                        } else {
                          _displayedMonth = 12;
                          _displayedYear--;
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  // Sonraki ay
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right,
                        color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (_displayedMonth < 12) {
                          _displayedMonth++;
                        } else {
                          _displayedMonth = 1;
                          _displayedYear++;
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Haftanın günleri başlıkları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeekdayHeader('Pt'),
              _buildWeekdayHeader('Sa'),
              _buildWeekdayHeader('Ça'),
              _buildWeekdayHeader('Pe'),
              _buildWeekdayHeader('Cu'),
              _buildWeekdayHeader('Ct'),
              _buildWeekdayHeader('Pa'),
            ],
          ),
          const SizedBox(height: 8),

          // Takvim günleri grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              // Önceki ayın günleri
              if (index < previousMonthDays) {
                final day = daysInPreviousMonth - previousMonthDays + index + 1;
                return _buildCalendarDay(day, isCurrentMonth: false);
              }
              // Mevcut ayın günleri
              else if (index < previousMonthDays + daysInMonth) {
                final day = index - previousMonthDays + 1;
                final actualDate =
                    DateTime(_displayedYear, _displayedMonth, day);

                // Seçilen tarih ile karşılaştır
                final isSelected = _selectedDate.year == actualDate.year &&
                    _selectedDate.month == actualDate.month &&
                    _selectedDate.day == actualDate.day;

                // Bugün kontrolü
                final isToday = now.year == actualDate.year &&
                    now.month == actualDate.month &&
                    now.day == actualDate.day;

                // Seçilebilir tarih kontrolü
                // - Bugünden önce olamaz
                // - Bugünden en fazla 14 gün sonra olabilir
                final isPastDate =
                    actualDate.isBefore(DateTime(now.year, now.month, now.day));
                final isFutureLimit = actualDate.isAfter(lastBookableDate);
                final isSelectable = !isPastDate && !isFutureLimit;

                return GestureDetector(
                  onTap: isSelectable
                      ? () {
                          setState(() {
                            _selectedDate = actualDate;
                          });
                        }
                      : null,
                  child: _buildCalendarDay(
                    day,
                    isCurrentMonth: true,
                    isSelected: isSelected,
                    isToday: isToday,
                    isSelectable: isSelectable,
                  ),
                );
              }
              // Sonraki ayın günleri
              else {
                final day = index - previousMonthDays - daysInMonth + 1;
                return _buildCalendarDay(day, isCurrentMonth: false);
              }
            },
          ),
        ],
      ),
    );
  }

  // Takvim günü widget'ı
  Widget _buildCalendarDay(
    int day, {
    bool isCurrentMonth = true,
    bool isSelected = false,
    bool isToday = false,
    bool isSelectable = true,
  }) {
    // Geçerli ay için renklendirme
    Color textColor = isCurrentMonth
        ? (isSelectable ? Colors.white : Colors.grey[600]!)
        : Colors.grey[700]!;

    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.transparent;

    if (isSelected) {
      backgroundColor = Colors.green;
      textColor = Colors.white;
      borderColor = Colors.green;
    } else if (isToday) {
      textColor = Colors.white;
      borderColor = Colors.grey[400]!;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 0 : 1,
        ),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight:
                isSelected || isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Haftanın günü başlık widget'ı
  Widget _buildWeekdayHeader(String text) {
    return SizedBox(
      width: 30,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ADIM 3: Adres Bilgileri
  Widget _buildAddressStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Adres Bilgileri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Atıklarınızın alınacağı adresi seçin',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Harita görünümü (sahte)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.map,
                size: 80,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Adres seçme
          Column(
            children: [
              // Kayıtlı adres
              RadioListTile<String>(
                title: const Text(
                  'Ev Adresim',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(_homeAddress),
                value: 'home',
                groupValue: _selectedAddress,
                activeColor: const Color(0xFF8BC399),
                onChanged: (value) {
                  setState(() {
                    _selectedAddress = value!;
                  });
                },
              ),

              // Farklı adres
              RadioListTile<String>(
                title: const Text(
                  'Farklı Adres',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 'custom',
                groupValue: _selectedAddress,
                activeColor: const Color(0xFF8BC399),
                onChanged: (value) {
                  setState(() {
                    _selectedAddress = value!;
                  });
                },
              ),

              // Farklı adres seçiliyse adres girişi
              if (_selectedAddress == 'custom')
                Padding(
                  padding:
                      const EdgeInsets.only(left: 48.0, right: 16.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: 'Adres girin',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Haritadan konum seçme
                        },
                        icon: const Icon(Icons.location_on, size: 16),
                        label: const Text('Haritadan Seç'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8BC399),
                          side: const BorderSide(color: Color(0xFF8BC399)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const Spacer(),

          // İleri butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAddress()
                  ? () {
                      setState(() {
                        _currentStep = 'confirmation';
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                disabledBackgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'İLERİ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Adres seçiminin geçerli olup olmadığını kontrol et
  bool _validateAddress() {
    if (_selectedAddress == 'home') return true;
    return _addressController.text.trim().isNotEmpty;
  }

  // ADIM 4: Onay
  Widget _buildConfirmationStep() {
    // Seçilen atıkları string listesi halinde göster
    final wasteList = _selectedWasteAmounts.entries
        .map((e) => '${e.value} ${_getWasteUnit(e.key)} ${e.key}')
        .join(', ');

    // Adres
    final address =
        _selectedAddress == 'home' ? _homeAddress : _addressController.text;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Randevu Özeti',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Atık bilgileri
          _buildConfirmationItem(
            icon: Icons.delete_outline,
            title: 'Atık Türleri',
            content: wasteList,
          ),

          const SizedBox(height: 16),

          // Tarih ve saat
          _buildConfirmationItem(
            icon: Icons.event,
            title: 'Tarih ve Saat',
            content:
                '${_selectedDate.day} ${_getMonthNameFull(_selectedDate.month)} ${_selectedDate.year} - $_selectedTime',
          ),

          const SizedBox(height: 16),

          // Adres
          _buildConfirmationItem(
            icon: Icons.location_on,
            title: 'Adres',
            content: address,
          ),

          const SizedBox(height: 16),

          // Not
          if (_noteController.text.isNotEmpty)
            _buildConfirmationItem(
              icon: Icons.notes,
              title: 'Not',
              content: _noteController.text,
            ),

          if (_noteController.text.isNotEmpty) const SizedBox(height: 16),

          // Fotoğraflar
          if (_wastePhotos.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.photo, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    const Text(
                      'Fotoğraflar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _wastePhotos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(_wastePhotos[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

          const Spacer(),

          // Onay bilgisi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber[800]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Randevu Onayı',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Randevunuz oluşturulduktan sonra onay bekleyecektir.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Randevu oluştur butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'RANDEVU OLUŞTUR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Onay sayfası öğesi
  Widget _buildConfirmationItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Atık türüne göre birim döndürür
  String _getWasteUnit(String wasteType) {
    for (var waste in _wasteTypes) {
      if (waste['name'] == wasteType) {
        return waste['unit'];
      }
    }
    return 'Kg';
  }

  /// Randevu oluştur veya güncelle
  void _saveAppointment() {
    // Atık detayları
    final wasteDetails = _selectedWasteAmounts.entries
        .map((e) => {
              'type': e.key,
              'amount': e.value,
              'unit': _getWasteUnit(e.key),
            })
        .toList();

    // Adres
    final address =
        _selectedAddress == 'home' ? _homeAddress : _addressController.text;

    // Randevu verisi
    final appointmentData = {
      'date':
          '${_selectedDate.day} ${_getMonthNameFull(_selectedDate.month)} ${_selectedDate.year}',
      'time': _selectedTime,
      'type': 'Evden Alma',
      'status': 'Bekliyor',
      'wasteType': _getWasteTypesString(),
      'wasteDetails': wasteDetails,
      'address': address,
      'note': _noteController.text,
      // Fotoğraflar burada kaydedilmeli, backend veya local storage entegrasyonu gerekecek
    };

    // Callback'i çağır
    widget.onSaveAppointment(appointmentData);

    // Başarı mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Randevunuz oluşturuldu!'),
        backgroundColor: Colors.green,
      ),
    );

    // Sayfayı kapat
    Navigator.of(context).pop();
  }

  /// Atık türlerini string olarak döndürür
  String _getWasteTypesString() {
    return _selectedWasteAmounts.keys.join(', ');
  }

  /// Ayın tam adını döndürür
  String _getMonthNameFull(int month) {
    switch (month) {
      case 1:
        return 'Ocak';
      case 2:
        return 'Şubat';
      case 3:
        return 'Mart';
      case 4:
        return 'Nisan';
      case 5:
        return 'Mayıs';
      case 6:
        return 'Haziran';
      case 7:
        return 'Temmuz';
      case 8:
        return 'Ağustos';
      case 9:
        return 'Eylül';
      case 10:
        return 'Ekim';
      case 11:
        return 'Kasım';
      case 12:
        return 'Aralık';
      default:
        return '';
    }
  }

  /// Ay adından sayıya çevirme
  int _getMonthNumber(String monthName) {
    switch (monthName) {
      case 'Ocak':
        return 1;
      case 'Şubat':
        return 2;
      case 'Mart':
        return 3;
      case 'Nisan':
        return 4;
      case 'Mayıs':
        return 5;
      case 'Haziran':
        return 6;
      case 'Temmuz':
        return 7;
      case 'Ağustos':
        return 8;
      case 'Eylül':
        return 9;
      case 'Ekim':
        return 10;
      case 'Kasım':
        return 11;
      case 'Aralık':
        return 12;
      default:
        return 1;
    }
  }
}
