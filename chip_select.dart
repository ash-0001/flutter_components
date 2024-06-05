import 'package:flutter/material.dart';

class ChipTypeSelector<T> extends StatefulWidget {
  final List<T> propertyTypes;
  final ValueChanged<List<T>> onSelected;
  final String hinttext;
  final bool isMultiSelectable;
  final void Function(List<T>) onChanged;
  final List<T>? initialValue;
  final bool disabled;

  const ChipTypeSelector({
    Key? key,
    required this.propertyTypes,
    required this.hinttext,
    required this.onSelected,
    required this.isMultiSelectable,
    required this.onChanged,
    this.initialValue,
    this.disabled = false, // Set default value for disabled
  }) : super(key: key);

  @override
  _ChipTypeSelectorState<T> createState() => _ChipTypeSelectorState<T>();
}

class _ChipTypeSelectorState<T> extends State<ChipTypeSelector<T>> {
  List<T> selectedTypes = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedTypes = List.from(widget.initialValue!);
    }
  }

  @override
  void didUpdateWidget(covariant ChipTypeSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedTypes = widget.initialValue != null
            ? List.from(widget.initialValue!)
            : [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey[50],
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  widget.hinttext,
                  style: const TextStyle(
                    color: Color(0xFF24214D),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12.0,
                runSpacing: 8.0,
                children: _buildChipTypeWidgets(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChipTypeWidgets() {
    return widget.propertyTypes.map((type) => _buildChip(type)).toList();
  }

  Widget _buildChip(T type) {
    final isSelected = selectedTypes.contains(type);
    final label = type.toString().length > 30
        ? '${type.toString().substring(0, 30)}...'
        : type.toString();
    final count = (type is MapEntry<String, int>) ? type.value : null;

    return GestureDetector(
      onTap: widget.disabled
          ? null
          : () {
              setState(() {
                if (widget.isMultiSelectable) {
                  if (isSelected) {
                    selectedTypes.remove(type);
                  } else {
                    selectedTypes.add(type);
                  }
                } else {
                  selectedTypes = isSelected ? [] : [type];
                }
              });
              widget.onSelected(selectedTypes);
              widget.onChanged(selectedTypes);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3768FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF3768FF) : Colors.transparent,
          ),
        ),
        child: Text(
          count != null ? '$label ($count)' : label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
