// lib/pages/wallet_page.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class WalletPage extends StatefulWidget {
  final UserModel user;

  const WalletPage({super.key, required this.user});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  // Puan-TL dönüşüm oranı
  final double _conversionRate = 0.1; // 1 puan = 0.1 TL
  
  // Örnek işlemler - Gerçek uygulamada veritabanından çekilecek
  late List<TransactionModel> _transactions;

  // Kullanıcının banka hesapları - Gerçek uygulamada veritabanından çekilecek
  final List<Map<String, dynamic>> _bankAccounts = [
    {
      'id': '1',
      'bank_name': 'Ziraat Bankası',
      'account_name': 'Admin',
      'iban': 'TR54 0001 0012 3456 7890 1234 56',
      'isDefault': true,
      'icon': 'assets/images/banks/ziraat.png',
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeTransactions();
  }
  
  void _initializeTransactions() {
    _transactions = [
      TransactionModel(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: 5.5,
        type: TransactionType.earn,
        description: 'Plastik şişe geri dönüşümü',
      ),
      TransactionModel(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 10.25,
        type: TransactionType.earn,
        description: 'Kâğıt geri dönüşümü',
      ),
      TransactionModel(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 5)),
        amount: 15.0,
        type: TransactionType.spend,
        description: 'Marketden ürün alışverişi',
      ),
      TransactionModel(
        id: '4',
        date: DateTime.now().subtract(const Duration(days: 10)),
        amount: 20.0,
        type: TransactionType.withdraw,
        description: 'TL olarak çekildi',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Cüzdanım',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bakiye kartı
            _buildBalanceCard(),

            const SizedBox(height: 24),

            // Banka hesapları başlığı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Banka Hesaplarım',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showAddBankAccountBottomSheet();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Hesap Ekle'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Banka hesapları
            _bankAccounts.isEmpty
                ? _buildEmptyBankAccounts()
                : _buildBankAccountsList(),

            const SizedBox(height: 24),

            // İşlem geçmişi
            _buildTransactionHistory(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showConvertToTLBottomSheet();
        },
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.currency_exchange, color: Colors.white),
        label: const Text(
          'Puanları TL\'ye Çevir',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Bakiye kartı
  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF8BC399)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mevcut Bakiye',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.recycling,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'DönüşCoin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${widget.user.walletBalance.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'Puan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'TL Değeri: ₺${(widget.user.walletBalance * _conversionRate).toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showConvertToTLBottomSheet();
                  },
                  icon: const Icon(Icons.currency_exchange),
                  label: const Text('TL\'ye Çevir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Bakiye geçmişini göster
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('Geçmiş'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Boş banka hesapları görünümü
  Widget _buildEmptyBankAccounts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.account_balance,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Henüz banka hesabınız bulunmuyor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Para çekebilmek için bir banka hesabı eklemelisiniz',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _showAddBankAccountBottomSheet();
              },
              icon: const Icon(Icons.add),
              label: const Text('Banka Hesabı Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Banka hesapları listesi
  Widget _buildBankAccountsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bankAccounts.length,
      itemBuilder: (context, index) {
        final account = _bankAccounts[index];
        return _buildBankAccountCard(account, index);
      },
    );
  }

  // Banka hesap kartı
  Widget _buildBankAccountCard(Map<String, dynamic> account, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Başlık kısmı
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Banka logosu
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                // Banka adı
                Expanded(
                  child: Text(
                    account['bank_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Varsayılan göstergesi
                if (account['isDefault'])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF2E7D32),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Varsayılan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                // İşlem menüsü
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    if (!account['isDefault'])
                      PopupMenuItem(
                        value: 'setDefault',
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 8),
                            Text('Varsayılan Yap'),
                          ],
                        ),
                        onTap: () {
                          _setDefaultBankAccount(index);
                        },
                      ),
                    PopupMenuItem(
                      value: 'edit',
                      child: const Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 8),
                          Text('Düzenle'),
                        ],
                      ),
                      onTap: () {
                        // Bottom sheet gösteriliyor ama biraz gecikmeli (popup menü kapansın diye)
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => _showEditBankAccountBottomSheet(account, index),
                        );
                      },
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () {
                        // Dialog gösteriliyor ama biraz gecikmeli (popup menü kapansın diye)
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => _showDeleteBankAccountDialog(index),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // IBAN
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IBAN',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            account['iban'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('IBAN kopyalandı'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Hesap sahibi
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hesap Sahibi',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            account['account_name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

  // İşlem geçmişi
  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'İşlem Geçmişi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Tüm işlemleri göster
              },
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _transactions.isEmpty
            ? _buildEmptyTransactions()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionItem(transaction);
                },
              ),
      ],
    );
  }

  // Boş işlem geçmişi
  Widget _buildEmptyTransactions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz işlem geçmişiniz yok',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Atık satışı yaptığınızda işlemleriniz burada görünecek',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // İşlem kartı
  Widget _buildTransactionItem(TransactionModel transaction) {
    // İşlem tipine göre ikon ve renk belirleme
    IconData icon = transaction.icon;
    Color iconColor = transaction.color;

    // İşlem tipine göre metin belirleme
    String typeText;
    switch (transaction.type) {
      case TransactionType.earn:
        typeText = 'Kazanılan Puan';
        break;
      case TransactionType.spend:
        typeText = 'Harcanan Puan';
        break;
      case TransactionType.withdraw:
        typeText = 'TL\'ye Çevrilen';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  transaction.formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (transaction.description.isNotEmpty)
                  Text(
                    transaction.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.type == TransactionType.earn
                    ? '+${transaction.amount.toStringAsFixed(1)}'
                    : '-${transaction.amount.toStringAsFixed(1)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transaction.type == TransactionType.earn
                      ? Colors.green
                      : Colors.red,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: transaction.type == TransactionType.earn
                      ? Colors.green[50]
                      : transaction.type == TransactionType.withdraw
                          ? Colors.red[50]
                          : Colors.orange[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  transaction.type == TransactionType.withdraw
                      ? '₺${(transaction.amount * _conversionRate).toStringAsFixed(2)}'
                      : 'Puan',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == TransactionType.earn
                        ? Colors.green[700]
                        : transaction.type == TransactionType.withdraw
                            ? Colors.red[700]
                            : Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TL'ye çevirme bottom sheet
  void _showConvertToTLBottomSheet() {
    final TextEditingController amountController = TextEditingController();
    double amountToConvert = 0;
    double tlValue = 0;
    
    // Banka hesabı seçimi için
    String? selectedBankId = _bankAccounts.isEmpty ? null : _bankAccounts.firstWhere((account) => account['isDefault'], orElse: () => _bankAccounts.first)['id'];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Puanları TL\'ye Çevir',
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
                  const SizedBox(height: 20),
                  
                  // Bakiye kartı (mini)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Color(0xFF2E7D32),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mevcut Bakiye',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${widget.user.walletBalance.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Puan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Dönüşüm oranı
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dönüşüm Oranı',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '1 Puan = ${_conversionRate.toStringAsFixed(2)} TL değerindedir.',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Çevrilecek puan miktarı
                  const Text(
                    'Çevirmek İstediğiniz Puan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'Örn: 100',
                      prefixIcon: const Icon(Icons.recycling),
                      suffixText: 'Puan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        amountToConvert = double.tryParse(value) ?? 0;
                        tlValue = amountToConvert * _conversionRate;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dönüştürülecek TL değeri
                  const Text(
                    'Alacağınız TL Tutarı',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.currency_lira,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Toplam TL',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₺${tlValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum 10 puan çevirebilirsiniz.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Banka hesabı seçimi
                  const Text(
                    'Para Çekim Hesabı',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _bankAccounts.isEmpty 
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Banka Hesabı Bulunamadı',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Para çekebilmek için önce bir banka hesabı eklemelisiniz.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showAddBankAccountBottomSheet();
                            },
                            child: const Text('Hesap Ekle'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    )
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        prefixIcon: const Icon(Icons.account_balance),
                      ),
                      value: selectedBankId,
                      items: _bankAccounts.map((bank) {
                        return DropdownMenuItem<String>(
                          value: bank['id'],
                          child: Text(
                            '${bank['bank_name']} - ${_maskIban(bank['iban'])}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedBankId = value;
                        });
                      },
                    ),
                  
                  const Spacer(),
                  
                  // Onayla butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_bankAccounts.isEmpty || amountToConvert < 10 || amountToConvert > widget.user.walletBalance)
                          ? null
                          : () {
                              final selectedBank = _bankAccounts.firstWhere((bank) => bank['id'] == selectedBankId);
                              _processTLConversion(amountToConvert, tlValue, selectedBank);
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'TL\'ye Çevir',
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
  
  // IBAN maskeleme
  String _maskIban(String iban) {
    if (iban.length > 8) {
      return '${iban.substring(0, 4)}...${iban.substring(iban.length - 4)}';
    }
    return iban;
  }
  
  // TL'ye çevirme işlemini gerçekleştir
  void _processTLConversion(double amount, double tlAmount, Map<String, dynamic> selectedBank) {
    // Bakiyeyi güncelle
    setState(() {
      // Gerçek uygulamada bu değer kullanıcı modelinde güncellenecek
      // widget.user.walletBalance -= amount;
      
      // Yeni işlem ekle
      _transactions.insert(0, TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        amount: amount,
        type: TransactionType.withdraw,
        description: '${selectedBank['bank_name']} hesabına TL transferi',
      ));
    });
    
    // Başarılı mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${amount.toStringAsFixed(1)} puan başarıyla TL\'ye çevrildi (₺${tlAmount.toStringAsFixed(2)})'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
    
    // Bildirim diyalogu göster
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text('İşlem Başarılı'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${amount.toStringAsFixed(1)} puanınız ₺${tlAmount.toStringAsFixed(2)} olarak ${selectedBank['bank_name']} hesabınıza aktarılacaktır.'),
              const SizedBox(height: 12),
              const Text(
                'Ödeme 24 saat içinde hesabınıza yansıyacaktır.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
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
  
  // Banka hesabı ekleme bottom sheet
  void _showAddBankAccountBottomSheet() {
    final TextEditingController bankNameController = TextEditingController();
    final TextEditingController accountNameController = TextEditingController();
    final TextEditingController ibanController = TextEditingController();
    bool isDefaultAccount = _bankAccounts.isEmpty;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // Klavye açıldığında içerik yukarı kaymasını sağlar
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Başlık
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Banka Hesabı Ekle',
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
                    const SizedBox(height: 20),
                    
                    // Banka adı
                    const Text(
                      'Banka Adı',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: bankNameController,
                      decoration: InputDecoration(
                        hintText: 'Örn: Ziraat Bankası',
                        prefixIcon: const Icon(Icons.account_balance),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Hesap sahibi adı
                    const Text(
                      'Hesap Sahibi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: accountNameController,
                      decoration: InputDecoration(
                        hintText: 'Örn: Ahmet Yılmaz',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // IBAN
                    const Text(
                      'IBAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: ibanController,
                      decoration: InputDecoration(
                        hintText: 'TR00 0000 0000 0000 0000 0000 00',
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Varsayılan olarak ayarla
                    CheckboxListTile(
                      title: const Text('Varsayılan hesap olarak ayarla'),
                      value: isDefaultAccount,
                      onChanged: (value) {
                        setState(() {
                          isDefaultAccount = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 24),
                    
                    // Ekle butonu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (bankNameController.text.isEmpty ||
                              accountNameController.text.isEmpty ||
                              ibanController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Lütfen tüm alanları doldurun'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          
                          // Banka hesabı ekle
                          _addBankAccount(
                            bankNameController.text,
                            accountNameController.text,
                            ibanController.text,
                            isDefaultAccount,
                          );
                          
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Hesabı Ekle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  // Banka hesabı düzenleme bottom sheet
  void _showEditBankAccountBottomSheet(Map<String, dynamic> account, int index) {
    final TextEditingController bankNameController = TextEditingController(text: account['bank_name']);
    final TextEditingController accountNameController = TextEditingController(text: account['account_name']);
    final TextEditingController ibanController = TextEditingController(text: account['iban']);
    bool isDefaultAccount = account['isDefault'];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // Klavye açıldığında içerik yukarı kaymasını sağlar
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Başlık
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Banka Hesabı Düzenle',
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
                    const SizedBox(height: 20),
                    
                    // Banka adı
                    const Text(
                      'Banka Adı',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: bankNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.account_balance),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Hesap sahibi adı
                    const Text(
                      'Hesap Sahibi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: accountNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // IBAN
                    const Text(
                      'IBAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: ibanController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Varsayılan olarak ayarla
                    if (!account['isDefault'])
                      CheckboxListTile(
                        title: const Text('Varsayılan hesap olarak ayarla'),
                        value: isDefaultAccount,
                        onChanged: (value) {
                          setState(() {
                            isDefaultAccount = value ?? false;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    const SizedBox(height: 24),
                    
                    // Güncelle butonu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (bankNameController.text.isEmpty ||
                              accountNameController.text.isEmpty ||
                              ibanController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Lütfen tüm alanları doldurun'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          
                          // Banka hesabını güncelle
                          _updateBankAccount(
                            index,
                            bankNameController.text,
                            accountNameController.text,
                            ibanController.text,
                            isDefaultAccount,
                          );
                          
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Güncelle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  // Banka hesabı silme dialog
  void _showDeleteBankAccountDialog(int index) {
    final account = _bankAccounts[index];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Banka Hesabını Sil'),
          content: Text('${account['bank_name']} hesabını silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Eğer varsayılan hesap siliniyorsa ve başka hesap varsa
                  // ilk hesabı varsayılan yap
                  if (account['isDefault'] && _bankAccounts.length > 1) {
                    // Silinecek hesabı çıkar
                    _bankAccounts.removeAt(index);
                    // Kalan hesaplardan birini varsayılan yap
                    _bankAccounts[0]['isDefault'] = true;
                  } else {
                    // Normal silme işlemi
                    _bankAccounts.removeAt(index);
                  }
                });
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Banka hesabı silindi'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
  
  // Varsayılan banka hesabını değiştir
  void _setDefaultBankAccount(int index) {
    setState(() {
      // Önce tüm hesapları varsayılan olmaktan çıkar
      for (var account in _bankAccounts) {
        account['isDefault'] = false;
      }
      // Seçilen hesabı varsayılan yap
      _bankAccounts[index]['isDefault'] = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Varsayılan banka hesabı güncellendi'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }
  
  // Yeni banka hesabı ekle
  void _addBankAccount(String bankName, String accountName, String iban, bool isDefault) {
    setState(() {
      // Eğer yeni hesap varsayılan olacaksa, diğer hesapları varsayılan olmaktan çıkar
      if (isDefault) {
        for (var account in _bankAccounts) {
          account['isDefault'] = false;
        }
      }
      
      // Yeni hesabı ekle
      _bankAccounts.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'bank_name': bankName,
        'account_name': accountName,
        'iban': iban,
        'isDefault': isDefault,
        'icon': 'assets/images/banks/default.png',
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Banka hesabı eklendi'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }
  
  // Banka hesabını güncelle
  void _updateBankAccount(int index, String bankName, String accountName, String iban, bool isDefault) {
    setState(() {
      // Eğer bu hesap varsayılan yapılıyorsa, diğer hesapları varsayılan olmaktan çıkar
      if (isDefault && !_bankAccounts[index]['isDefault']) {
        for (var account in _bankAccounts) {
          account['isDefault'] = false;
        }
      }
      
      // Hesabı güncelle
      _bankAccounts[index] = {
        'id': _bankAccounts[index]['id'],
        'bank_name': bankName,
        'account_name': accountName,
        'iban': iban,
        'isDefault': isDefault,
        'icon': _bankAccounts[index]['icon'],
      };
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Banka hesabı güncellendi'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }
}