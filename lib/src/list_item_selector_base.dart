import 'package:flutter/material.dart';

class ListItemSelector extends StatefulWidget {
  final String? selectedValue;
  final List<String> items;
  final String? hintText;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String?>? validator;

  // Customization parameters
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? dropdownColor;
  final double? fontSize;
  final Color? hintColor;
  final Color? labelColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;
  final TextStyle? itemTextStyle;
  final double? elevation;
  final double iconSize;
  final bool isExpanded;

  // Custom item functionality
  final bool allowCustomItem;

  // Size control
  final double? width;
  final double? height;

  // Label widget
  final Widget? labelWidget;

  const ListItemSelector({
    Key? key,
    required this.selectedValue,
    required this.items,
    this.hintText,
    required this.onChanged,
    this.validator,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.dropdownColor,
    this.fontSize = 14.0,
    this.hintColor,
    this.labelColor,
    this.borderRadius = 8.0,
    this.contentPadding,
    this.suffixIcon,
    this.itemTextStyle,
    this.elevation = 8.0,
    this.iconSize = 24.0,
    this.isExpanded = true,
    this.width,
    this.height,
    this.labelWidget,
    this.allowCustomItem = false,
  }) : super(key: key);

  @override
  _ListItemSelectorState createState() => _ListItemSelectorState();
}

class _ListItemSelectorState extends State<ListItemSelector> {
  late TextEditingController _controller;
  late List<String> _dropdownItems;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedValue);
    _dropdownItems = List.from(widget.items);
    _selectedValue = widget.selectedValue;
  }

  void _handleValueChanged(String? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedValue = newValue;
      _controller.text = newValue;

      // If the custom item is enabled and it's not in the list, add it
      if (widget.allowCustomItem && !_dropdownItems.contains(newValue)) {
        _dropdownItems.add(newValue);
      }
    });

    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelWidget != null) widget.labelWidget!,
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: Column(
            children: [
              // Editable TextField for Custom Item Entry
              if (widget.allowCustomItem)
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: widget.borderColor ?? Colors.grey,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _handleValueChanged(value);
                    }
                  },
                ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.grey,
                    ),
                  ),
                ),
                value: _selectedValue,
                hint: Text(widget.hintText ?? "Select an option"),
                items: _dropdownItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: widget.itemTextStyle ?? TextStyle(fontSize: widget.fontSize),
                    ),
                  );
                }).toList(),
                onChanged: _handleValueChanged,
                validator: widget.validator,
                dropdownColor: widget.dropdownColor,
                elevation: widget.elevation?.toInt() ?? 8,
                icon: widget.suffixIcon ?? const Icon(Icons.arrow_drop_down_circle_outlined),
                iconSize: widget.iconSize,
                isExpanded: widget.isExpanded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
