// lib/pages/profile/support_page.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class SupportPage extends StatefulWidget {
  final UserModel user;

  const SupportPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  // Arama çubuğu controller
  final TextEditingController _searchController = TextEditingController();
  
  // Sık Sorulan Sorular
  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'Uygulamayı nasıl kullanabilirim?',
      'answer':
          'Uygulamayı kullanmak için öncelikle hesap oluşturmanız gerekir. Ardından ana sayfadan atık kategorileri arasından seçim yapabilir, evden alım randevusu oluşturabilir veya en yakın atık toplama merkezlerini görebilirsiniz.',
      'isExpanded': false,
    },
    {
      'question': 'Evden atık alımı nasıl çalışır?',
      'answer':
          'Evden atık alımı için atık topla sayfasından "Evden Al" seçeneğini seçebilirsiniz. Atık tipini, miktarını, alım tarihini ve adresinizi belirterek randevu oluşturabilirsiniz. Randevunuz onaylandıktan sonra, belirtilen tarih ve saatte ekiplerimiz adresinize gelecektir.',
      'isExpanded': false,
    },
    {
      'question': 'Atıklarımın karşılığında nasıl ödeme alırım?',
      'answer':
          'Atıklarınızın karşılığında kazandığınız tutarlar otomatik olarak uygulama içi cüzdanınıza eklenir. Cüzdanınızdaki bakiyeyi banka hesabınıza aktarabilirsiniz. Para çekme işlemi için "Profil > Cüzdan" kısmından işlem yapabilirsiniz.',
      'isExpanded': false,
    },
    {
      'question': 'Hangi atık türlerini geri dönüştürebilirim?',
      'answer':
          'Cam, kağıt, plastik, metal, elektronik, tekstil, organik atıklar, pil ve batarya gibi birçok atık türünü geri dönüştürebilirsiniz. Her atık türü için farklı geri dönüşüm değerleri uygulanmaktadır. Detaylı bilgi için uygulamanın ana sayfasındaki atık kategorileri bölümünü inceleyebilirsiniz.',
      'isExpanded': false,
    },
    {
      'question': 'Geri dönüşüm randevumu nasıl iptal edebilirim?',
      'answer':
          'Geri dönüşüm randevunuzu iptal etmek için "Profil > Atık Topla > Randevularım" bölümünden ilgili randevuyu seçip "Randevuyu İptal Et" butonuna tıklayabilirsiniz. Randevuya 24 saatten az bir süre kalmışsa iptal işlemi yapılamayabilir.',
      'isExpanded': false,
    },
  ];
  
  // İletişim kanalları
  final List<Map<String, dynamic>> _contactItems = [
    {
      'title': 'Canlı Destek',
      'description': 'Canlı destek ekibimiz ile görüşün',
      'icon': Icons.chat,
      'color': Colors.blue,
    },
    {
      'title': 'E-posta',
      'description': 'destek@donusturkiye.com',
      'icon': Icons.email,
      'color': Colors.orange,
    },
    {
      'title': 'Telefon',
      'description': '+90 555 123 45 67',
      'icon': Icons.phone,
      'color': Colors.green,
    },
    {
      'title': 'WhatsApp',
      'description': 'WhatsApp üzerinden yazın',
      'icon': Icons.message,
      'color': Colors.green,
    },
  ];
  
  // İletişim formları
  final List<Map<String, dynamic>> _supportFormItems = [
    {
      'title': 'Teknik Sorun Bildir',
      'description': 'Uygulama hatası veya teknik sorunlar',
      'icon': Icons.bug_report,
      'color': Colors.red,
    },
    {
      'title': 'Öneri ve Görüş',
      'description': 'Uygulama hakkında görüş ve önerileriniz',
      'icon': Icons.lightbulb,
      'color': Colors.amber,
    },
    {
      'title': 'Şikayet',
      'description': 'Hizmet veya personel hakkında şikayet',
      'icon': Icons.report_problem,
      'color': Colors.deepOrange,
    },
  ];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destek'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Arama çubuğu
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Soru veya anahtar kelime ara',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Arama işlemleri
              },
            ),
          ),
          
          // İçerik
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // SSS başlığı
                _buildSectionTitle('Sık Sorulan Sorular'),
                
                // SSS listesi
                _buildFaqList(),
                
                const SizedBox(height: 24),
                
                // Destek Kanalları
                _buildSectionTitle('Destek Kanalları'),
                
                // İletişim kanalları
                _buildContactChannels(),
                
                const SizedBox(height: 24),// Destek Formları
                _buildSectionTitle('Destek Formları'),
                
                // Destek formları
                _buildSupportForms(),
                
                const SizedBox(height: 24),
                
                // Yasal Bilgiler
                _buildSectionTitle('Yasal Bilgiler'),
                
                // Yasal bilgiler listesi
                _buildLegalInfos(),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Bölüm başlığı
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  // SSS widget'ı
  Widget _buildFaqList() {
    return Container(
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
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: Colors.grey[200],
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _faqItems[index]['isExpanded'] = !isExpanded;
          });
        },
        children: _faqItems.map<ExpansionPanel>((item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  item['question'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: Colors.green[600],
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                item['answer'],
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            isExpanded: item['isExpanded'],
          );
        }).toList(),
      ),
    );
  }
  
  // İletişim kanalları
  Widget _buildContactChannels() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _contactItems.length,
      itemBuilder: (context, index) {
        final item = _contactItems[index];
        return GestureDetector(
          onTap: () {
            // İlgili iletişim kanalına yönlendirme
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item['title']} sayfasına yönlendiriliyorsunuz'),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    item['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Destek formları
  Widget _buildSupportForms() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _supportFormItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _supportFormItems[index];
        return GestureDetector(
          onTap: () {
            // İlgili form sayfasına yönlendirme
            _showSupportFormDialog(item['title']);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Yasal bilgiler
  Widget _buildLegalInfos() {
    return Container(
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
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Kullanım Koşulları',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.description,
                color: Colors.green[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Kullanım koşulları sayfasına yönlendir
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              'Gizlilik Politikası',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.privacy_tip,
                color: Colors.green[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Gizlilik politikası sayfasına yönlendir
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              'Çerez Politikası',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.cookie,
                color: Colors.green[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Çerez politikası sayfasına yönlendir
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              'Lisanslar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.verified_user,
                color: Colors.green[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Lisanslar sayfasına yönlendir
            },
          ),
        ],
      ),
    );
  }
  
  // Destek formu diyaloğu
  void _showSupportFormDialog(String title) {
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Konu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Mesaj',
                  hintText: 'Lütfen detaylı açıklama yapınız',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Dosya ekleme
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Dosya Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İPTAL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (subjectController.text.isEmpty || messageController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen tüm alanları doldurun'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              // Form gönderme işlemi
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mesajınız iletildi. En kısa sürede dönüş yapılacaktır.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('GÖNDER'),
          ),
        ],
      ),
    );
  }
}