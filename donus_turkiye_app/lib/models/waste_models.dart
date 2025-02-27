// lib/models/waste_models.dart

import 'package:flutter/material.dart';

/// Ana atık kategori sınıfı
abstract class WasteCategory {
  final String name;
  final IconData icon;
  final List<WasteSubcategory> subcategories;
  bool isSelected;

  WasteCategory({
    required this.name,
    required this.icon,
    required this.subcategories,
    this.isSelected = false,
  });

  /// Kategori seçildiğinde hesaplama yapmak için kullanılacak ortalama fiyat
  double get averagePrice {
    if (subcategories.isEmpty) return 0;
    return subcategories.map((s) => s.pricePerKg).reduce((a, b) => a + b) /
        subcategories.length;
  }
}

/// Atık alt kategori sınıfı
class WasteSubcategory {
  final String name;
  final double pricePerKg;
  bool isSelected;

  WasteSubcategory({
    required this.name,
    required this.pricePerKg,
    this.isSelected = false,
  });
}

/// Kağıt atıklar kategorisi
class PaperWaste extends WasteCategory {
  PaperWaste()
      : super(
          name: 'Kağıt Atıklar',
          icon: Icons.description,
          subcategories: [
            WasteSubcategory(name: 'Hurda Kağıt ve Karton', pricePerKg: 4.5),
            WasteSubcategory(name: 'Kullanılmış Gazete', pricePerKg: 2.80),
            WasteSubcategory(
                name: 'Karışık Kağıt', pricePerKg: 3.5), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Beyaz Kağıt (A4)', pricePerKg: 5.2), // Yaklaşık fiyat
          ],
        );
}

/// Plastik atıklar kategorisi
class PlasticWaste extends WasteCategory {
  PlasticWaste()
      : super(
          name: 'Plastik Atıklar',
          icon: Icons.shopping_bag,
          subcategories: [
            WasteSubcategory(name: 'PET Şişe', pricePerKg: 10.54),
            WasteSubcategory(name: 'Polipropilen (PP)', pricePerKg: 12.70),
            WasteSubcategory(
                name: 'HDPE (Yüksek Yoğunluk)',
                pricePerKg: 8.90), // Yaklaşık fiyat
            WasteSubcategory(name: 'PVC', pricePerKg: 7.50), // Yaklaşık fiyat
          ],
        );
}

/// Cam atıklar kategorisi
class GlassWaste extends WasteCategory {
  GlassWaste()
      : super(
          name: 'Cam Atıklar',
          icon: Icons.wine_bar,
          subcategories: [
            WasteSubcategory(
                name: 'Renkli Cam Şişe', pricePerKg: 1.2), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Beyaz Cam', pricePerKg: 1.5), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Amber Cam', pricePerKg: 1.3), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Kırık Cam', pricePerKg: 0.9), // Yaklaşık fiyat
          ],
        );
}

/// Metal atıklar kategorisi
class MetalWaste extends WasteCategory {
  MetalWaste()
      : super(
          name: 'Metal Atıklar',
          icon: Icons.blur_circular,
          subcategories: [
            WasteSubcategory(name: 'Soyma Bakır', pricePerKg: 315),
            WasteSubcategory(name: 'Alüminyum Kutu', pricePerKg: 5),
            WasteSubcategory(
                name: 'Hurda Demir', pricePerKg: 3.8), // Yaklaşık fiyat
            WasteSubcategory(name: 'Pirinç', pricePerKg: 120), // Yaklaşık fiyat
          ],
        );
}

/// Elektronik atıklar kategorisi
class ElectronicWaste extends WasteCategory {
  ElectronicWaste()
      : super(
          name: 'Elektronik Atıklar',
          icon: Icons.devices,
          subcategories: [
            WasteSubcategory(name: 'UPS Hurda (Akü ve Devre)', pricePerKg: 14),
            WasteSubcategory(
                name: 'Büyük Otomotiv ve UPS Aküleri', pricePerKg: 18),
            WasteSubcategory(
                name: 'Bilgisayar Anakartları',
                pricePerKg: 22), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Cep Telefonu', pricePerKg: 30), // Yaklaşık fiyat
          ],
        );
}

/// Organik atıklar kategorisi
class OrganicWaste extends WasteCategory {
  OrganicWaste()
      : super(
          name: 'Organik Atıklar',
          icon: Icons.eco,
          subcategories: [
            WasteSubcategory(
                name: 'Bitkisel Atıklar', pricePerKg: 0.5), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Kompost Malzemesi', pricePerKg: 0.8), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Yemek Atıkları', pricePerKg: 0.3), // Yaklaşık fiyat
          ],
        );
}

/// Tekstil atıklar kategorisi
class TextileWaste extends WasteCategory {
  TextileWaste()
      : super(
          name: 'Tekstil Atıkları',
          icon: Icons.checkroom,
          subcategories: [
            WasteSubcategory(
                name: 'Kullanılmış Giysi', pricePerKg: 2.5), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Endüstriyel Tekstil', pricePerKg: 3.2), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Kumaş Parçaları', pricePerKg: 2.0), // Yaklaşık fiyat
          ],
        );
}

/// Lastik ve kauçuk atıklar kategorisi
class RubberWaste extends WasteCategory {
  RubberWaste()
      : super(
          name: 'Lastik ve Kauçuk',
          icon: Icons.tire_repair,
          subcategories: [
            WasteSubcategory(
                name: 'Otomobil Lastiği', pricePerKg: 1.2), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Kauçuk Atıklar', pricePerKg: 1.8), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Endüstriyel Lastik', pricePerKg: 2.2), // Yaklaşık fiyat
          ],
        );
}

/// Pil ve batarya atıklar kategorisi
class BatteryWaste extends WasteCategory {
  BatteryWaste()
      : super(
          name: 'Pil ve Batarya',
          icon: Icons.battery_full,
          subcategories: [
            WasteSubcategory(
                name: 'Kurşun Asit Akü', pricePerKg: 9.5), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Lityum İyon Batarya', pricePerKg: 16), // Yaklaşık fiyat
            WasteSubcategory(
                name: 'Alkali Piller', pricePerKg: 5.5), // Yaklaşık fiyat
          ],
        );
}

/// Tüm atık kategorilerini içeren sınıf
class WasteCategoryManager {
  static final List<WasteCategory> allCategories = [
    PaperWaste(),
    PlasticWaste(),
    GlassWaste(),
    MetalWaste(),
    ElectronicWaste(),
    OrganicWaste(),
    TextileWaste(),
    RubberWaste(),
    BatteryWaste(),
  ];

  static List<WasteCategory> getSelectedCategories() {
    return allCategories.where((category) => category.isSelected).toList();
  }

  static void resetSelections() {
    for (var category in allCategories) {
      category.isSelected = false;
      for (var subcategory in category.subcategories) {
        subcategory.isSelected = false;
      }
    }
  }
}
