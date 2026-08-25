import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/property_filter.dart';
import 'package:propertyhub/presentation/widgets/common/category_chip.dart';
import 'package:propertyhub/presentation/widgets/common/primary_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final PropertyFilter initialFilter;
  final ValueChanged<PropertyFilter> onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late PropertyFilter _filter;

  final TextEditingController _minAreaController = TextEditingController();
  final TextEditingController _maxAreaController = TextEditingController();

  final List<String> _categories = ['sale', 'rent', 'commercial'];
  final List<String> _propertyTypes = ['apartment', 'house', 'villa', 'condo', 'land'];

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    if (_filter.minArea != null) _minAreaController.text = _filter.minArea.toString();
    if (_filter.maxArea != null) _maxAreaController.text = _filter.maxArea.toString();
  }

  @override
  void dispose() {
    _minAreaController.dispose();
    _maxAreaController.dispose();
    super.dispose();
  }

  void _applyAreaFilters() {
    double? minA = double.tryParse(_minAreaController.text);
    double? maxA = double.tryParse(_maxAreaController.text);
    _filter = _filter.copyWith(minArea: minA, maxArea: maxA);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Category'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _categories.map((cat) {
                      return CategoryChip(
                        label: cat.toUpperCase(),
                        isSelected: _filter.category == cat,
                        onTap: () {
                          setState(() {
                            if (_filter.category == cat) {
                              _filter = _filter.copyWith(clearCategory: true);
                            } else {
                              _filter = _filter.copyWith(category: cat);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Property Type'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _propertyTypes.map((type) {
                      return CategoryChip(
                        label: type[0].toUpperCase() + type.substring(1),
                        isSelected: _filter.propertyType == type,
                        onTap: () {
                          setState(() {
                            if (_filter.propertyType == type) {
                              _filter = _filter.copyWith(clearPropertyType: true);
                            } else {
                              _filter = _filter.copyWith(propertyType: type);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Price Range (\$)'),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: RangeValues(_filter.minPrice ?? 0, _filter.maxPrice ?? 10000000),
                    min: 0,
                    max: 10000000,
                    divisions: 100,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.surfaceVariant,
                    onChanged: (values) {
                      setState(() {
                        _filter = _filter.copyWith(
                          minPrice: values.start,
                          maxPrice: values.end,
                        );
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${(_filter.minPrice ?? 0).toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}', style: AppTypography.labelMedium),
                        Text('\$${(_filter.maxPrice ?? 10000000).toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}', style: AppTypography.labelMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Bedrooms'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildNumberSelect('Any', _filter.bedrooms == null, () {
                        setState(() => _filter = _filter.copyWith(clearBedrooms: true));
                      }),
                      ...List.generate(4, (index) {
                        int val = index + 1;
                        return Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: _buildNumberSelect('$val${val == 4 ? '+' : ''}', _filter.bedrooms == val, () {
                            setState(() => _filter = _filter.copyWith(bedrooms: val));
                          }),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Bathrooms'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildNumberSelect('Any', _filter.bathrooms == null, () {
                        setState(() => _filter = _filter.copyWith(clearBathrooms: true));
                      }),
                      ...List.generate(4, (index) {
                        int val = index + 1;
                        return Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: _buildNumberSelect('$val${val == 4 ? '+' : ''}', _filter.bathrooms == val, () {
                            setState(() => _filter = _filter.copyWith(bathrooms: val));
                          }),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Area (Sq. Ft)'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(_minAreaController, 'Min Area'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_maxAreaController, 'Max Area'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Container(
            padding: EdgeInsets.only(
              left: 16, 
              right: 16, 
              top: 12, 
              bottom: MediaQuery.of(context).padding.bottom + 12
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _filter = PropertyFilter();
                          _minAreaController.clear();
                          _maxAreaController.clear();
                        });
                        widget.onApply(_filter);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Reset All',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 44,
                    child: PrimaryButton(
                      text: 'Apply Filters',
                      onPressed: () {
                        _applyAreaFilters();
                        widget.onApply(_filter);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleLarge.copyWith(fontSize: 18),
    );
  }

  Widget _buildNumberSelect(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodySmall,
        filled: true,
        fillColor: AppColors.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      style: AppTypography.bodyMedium,
    );
  }
}
