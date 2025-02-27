// lib/pages/collect_waste_page.dart

import 'package:flutter/material.dart';
import '../models/waste_models.dart';
import '../models/user_model.dart';
import 'waste/waste_pickup_page.dart'; // Atık alma sayfası
import 'waste/waste_centers_page.dart'; // Yeni eklenen atık merkezleri sayfası

class CollectWastePage extends StatefulWidget {
  final UserModel user;
  final WasteCategory? initialCategory;

  const CollectWastePage({
    super.key,
    required this.user,
    this.initialCategory,
  });

  @override
  State<CollectWastePage> createState() => _CollectWastePageState();
}

class _CollectWastePageState extends State<CollectWastePage> {
  // Seçilen atık kategorisi
  WasteCategory? _selectedCategory;

  // Seçilen alt kategoriler ve miktarları
  final Map<String, double> _selectedAmounts = {};

  // Sayfa durumu
  String _currentView = 'main'; // 'main', 'editAppointment'
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '10:00';

  // Düzenlenen randevu indeksi
  int? _editingAppointmentIndex;

  // Takvim için görüntülenen ay ve yıl
  int _displayedMonth = DateTime.now().month;
  int _displayedYear = DateTime.now().year;

  // En çok kazandıran atık tipleri
  final List<Map<String, dynamic>> _topWastes = [
    {
      'name': 'Metal',
      'icon': Icons.blur_circular,
      'color': Colors.white,
      'rank': 1,
    },
    {
      'name': 'Alüminyum',
      'icon': Icons.layers,
      'color': Colors.white,
      'rank': 2,
    },
    {
      'name': 'Plastik',
      'icon': Icons.shopping_bag,
      'color': Colors.white,
      'rank': 3,
    },
  ];

  // Randevularım
  final List<Map<String, dynamic>> _appointments = [
    {
      'date': '25 Şubat 2025',
      'time': '14:30',
      'type': 'Evden Alma',
      'status': 'Onaylandı',
      'wasteType': 'Plastik, Metal',
    },
    {
      'date': '18 Mart 2025',
      'time': '10:00',
      'type': 'Evden Alma',
      'status': 'Bekliyor',
      'wasteType': 'Kağıt, Cam',
    },
  ];

  // Zaman seçenekleri
  final List<String> _timeSlots = [
    '09:00',
    '09:20',
    '09:40',
    '10:00',
    '10:20',
    '10:40',
    '11:00',
    '11:20',
    '11:40',
    '12:00',
    '12:20',
    '13:30',
    '14:00',
    '14:20',
    '14:40',
    '15:00',
    '15:20',
    '15:40',
    '16:00',
    '16:20',
    '16:40',
    '17:00'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      setState(() {
        _selectedCategory = widget.initialCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: _currentView != 'main'
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentView = 'main';
                    _editingAppointmentIndex =
                        null; // Düzenleme modundan çıkıldığında indeksi sıfırla
                  });
                },
              )
            : null,
      ),
      body: _buildCurrentView(),
    );
  }

  String _getAppBarTitle() {
    switch (_currentView) {
      case 'editAppointment':
        return 'Randevu Düzenle';
      default:
        return 'Atık Topla';
    }
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 'editAppointment':
        return _buildEditAppointmentView();
      default:
        return _buildMainView();
    }
  }

  // Randevu Düzenleme Görünümü
  Widget _buildEditAppointmentView() {
    if (_editingAppointmentIndex == null ||
        _editingAppointmentIndex! >= _appointments.length) {
      return const Center(child: Text('Randevu bulunamadı'));
    }

    // Düzenlenen randevu
    final appointment = _appointments[_editingAppointmentIndex!];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Düzenleme bilgi kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Randevu Düzenleniyor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Randevu bilgilerinizi güncelleyebilirsiniz.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Atık: ${appointment['wasteType']}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tarih Seçim Başlığı
            const Text(
              'Randevu Tarihi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Takvim widget'ı
            _buildCalendarPicker(),

            const SizedBox(height: 24),

            // Saat Seçim
            const Text(
              'Randevu Saati',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
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

            const SizedBox(height: 36),

            // Randevu Güncelle Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Randevuyu güncelle
                    _appointments[_editingAppointmentIndex!] = {
                      'date':
                          '${_selectedDate.day} ${_getMonthNameFull(_selectedDate.month)} ${_selectedDate.year}',
                      'time': _selectedTime,
                      'type': appointment['type'],
                      'status':
                          'Bekliyor', // Düzenlenen randevu bekliyor durumuna geçer
                      'wasteType': appointment['wasteType'],
                    };

                    // Ana görünüme dön
                    _currentView = 'main';
                    _editingAppointmentIndex = null;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Randevunuz güncellendi!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 63, 172, 69),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'RANDEVUYU GÜNCELLE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Randevu İptal Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Randevu İptali'),
                      content: const Text(
                          'Bu randevuyu iptal etmek istediğinizden emin misiniz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('VAZGEÇ'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              // Randevuyu listeden kaldır
                              _appointments.removeAt(_editingAppointmentIndex!);

                              // Ana görünüme dön
                              _currentView = 'main';
                              _editingAppointmentIndex = null;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Randevunuz iptal edildi'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          child: const Text('İPTAL ET'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'RANDEVUYU İPTAL ET',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // Ana Görünüm
  Widget _buildMainView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En Çok Kazandıran Atıklar
            _buildTopWastesSection(),

            const SizedBox(height: 24),

            // Hizmetler
            _buildServicesSection(),

            const SizedBox(height: 24),

            // Randevularım
            _buildAppointmentsSection(),

            // Alt kısımda Navigation Bar'ın gözükmesi için ekstra boşluk
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // Takvim widget'ı
  Widget _buildCalendarPicker() {
    // Bugünün tarihini al
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

  // Takvim günü widget'ı - Güncellenmiş versiyonu
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

  // En çok kazandıran atık tipleri bölümü
  Widget _buildTopWastesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF8BC399),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'En Çok Kazandıran 3 Atık',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _topWastes
                    .map((waste) => _buildTopWasteItem(waste))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tek bir en çok kazandıran atık öğesi
  Widget _buildTopWasteItem(Map<String, dynamic> waste) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: waste['color'],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                waste['icon'],
                color: Colors.grey[800],
                size: 30,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    waste['rank'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          waste['name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Hizmetler bölümü
  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hizmetler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Evden Al Hizmeti - Yeni sayfaya yönlendir
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WastePickupPage(
                        user: widget.user,
                        onSaveAppointment: (appointmentData) {
                          setState(() {
                            // Yeni randevu ekle
                            _appointments.add(appointmentData);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(right: 8),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping,
                        color: Colors.grey[700],
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Evden Al',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Atık Merkezi Hizmeti - Yeni atık merkezleri sayfasına yönlendir
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Atık merkezleri sayfasına yönlendir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WasteCentersPage(
                        user: widget.user,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(left: 8),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.grey[700],
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Atık Merkezi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Randevularım bölümü
  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Randevularım',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _appointments.isEmpty
            ? _buildEmptyAppointments()
            : Column(
                children: _appointments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final appointment = entry.value;
                  return _buildAppointmentItem(appointment, index);
                }).toList(),
              ),
      ],
    );
  }

  // Randevularım boş durumu
  Widget _buildEmptyAppointments() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Icon(
            Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz randevunuz bulunmuyor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni bir randevu oluşturmak için Evden Al hizmetini seçin',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(Map<String, dynamic> appointment, int index) {
    final isConfirmed = appointment['status'] == 'Onaylandı';
    final isWaiting = appointment['status'] == 'Bekliyor';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isConfirmed
                  ? const Color(0xFF8BC399).withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isConfirmed ? Icons.check_circle : Icons.access_time,
              color: isConfirmed ? const Color(0xFF2E7D32) : Colors.orange,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment['type'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment['date']} - ${appointment['time']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                if (appointment.containsKey('wasteType') &&
                    appointment['wasteType'] != 'Seçilmedi')
                  Text(
                    'Atık: ${appointment['wasteType']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isConfirmed
                      ? const Color(0xFF8BC399).withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  appointment['status'],
                  style: TextStyle(
                    color:
                        isConfirmed ? const Color(0xFF2E7D32) : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              // İşlem butonları - Sadece bekleyen randevular için göster
              if (isWaiting) // Sadece bekleyen randevular düzenlenebilir ve silinebilir
                Row(
                  children: [
                    // Düzenleme butonu
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // Yeni düzenleme sayfasına yönlendir
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WastePickupPage(
                              user: widget.user,
                              existingAppointment: appointment,
                              onSaveAppointment: (updatedData) {
                                setState(() {
                                  // Randevuyu güncelle
                                  _appointments[index] = updatedData;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    // Silme butonu - Sadece bekleyen randevular için
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        _showDeleteConfirmation(index);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

// Randevu silme onayı diyaloğunu gösteren metod
  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Randevu Silme'),
        content: const Text('Bu randevuyu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('VAZGEÇ'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // Randevuyu listeden kaldır
                _appointments.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Randevunuz silindi'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('SİL'),
          ),
        ],
      ),
    );
  }

// Ayın tam adını döndürür
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

// Ay adından sayıya çevirme
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
