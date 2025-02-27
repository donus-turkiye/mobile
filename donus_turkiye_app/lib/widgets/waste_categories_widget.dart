// lib/widgets/waste_categories_widget.dart

import 'package:flutter/material.dart';
import '../models/waste_models.dart';

class WasteCategoriesWidget extends StatefulWidget {
  final Function(List<WasteCategory>) onCategoriesSelected;

  const WasteCategoriesWidget({
    super.key,
    required this.onCategoriesSelected,
  });

  @override
  State<WasteCategoriesWidget> createState() => _WasteCategoriesWidgetState();
}

class _WasteCategoriesWidgetState extends State<WasteCategoriesWidget> {
  bool _isExpanded = false;
  final List<WasteCategory> _allCategories = WasteCategoryManager.allCategories;

  List<WasteCategory> get _selectedCategories => 
      _allCategories.where((category) => category.isSelected).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Kapat' : 'Tümünü Gör',
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Seçili kategorileri göster (maksimum 3)
        if (_selectedCategories.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _selectedCategories.take(3).map((category) => 
              _buildCategoryItem(category.icon, category.name, isSelected: true, onTap: () {
                _showSubcategoriesDialog(category);
              })
            ).toList(),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _allCategories.take(4).map((category) => 
              _buildCategoryItem(category.icon, category.name, onTap: () {
                _selectCategory(category);
              })
            ).toList(),
          ),
          
        // Genişletilmiş kategoriler
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 16),
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
            height: 250, // Yüksekliği sınırla
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(), // Kaydırmaya izin ver
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _allCategories.length,
              itemBuilder: (context, index) {
                final category = _allCategories[index];
                return InkWell(
                  onTap: () {
                    if (category.isSelected) {
                      _showSubcategoriesDialog(category);
                    } else {
                      _selectCategory(category);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: category.isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: category.isSelected 
                          ? Border.all(color: Colors.green, width: 1.5) 
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          category.icon,
                          color: category.isSelected ? Colors.green : Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: category.isSelected ? Colors.green : Colors.black,
                              fontWeight: category.isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _selectCategory(WasteCategory category) {
    setState(() {
      category.isSelected = !category.isSelected;
      
      // Maksimum 3 kategori seçilebilir
      if (_selectedCategories.length > 3) {
        category.isSelected = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('En fazla 3 kategori seçebilirsiniz!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (category.isSelected) {
        // Kategori ilk kez seçildiğinde alt kategorileri göster
        _showSubcategoriesDialog(category);
      }
    });
    
    // Seçilen kategorileri bildir
    widget.onCategoriesSelected(_selectedCategories);
  }

  void _showSubcategoriesDialog(WasteCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${category.name} Alt Kategorileri"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: category.subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = category.subcategories[index];
              return CheckboxListTile(
                title: Text(subcategory.name),
                subtitle: Text("${subcategory.pricePerKg.toStringAsFixed(2)} TL/Kg"),
                value: subcategory.isSelected,
                activeColor: Colors.green,
                onChanged: (bool? value) {
                  setState(() {
                    subcategory.isSelected = value ?? false;
                  });
                  Navigator.pop(context);
                  widget.onCategoriesSelected(_selectedCategories);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Kapat'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, {bool isSelected = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: Colors.green, width: 1.5) : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.green : Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
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
}