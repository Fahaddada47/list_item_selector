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
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
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
  bool _isCustomSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _dropdownItems = List.from(widget.items);
    _selectedValue = widget.selectedValue;
  }

  void _handleValueChanged(String? newValue) {
    setState(() {
      _selectedValue = newValue;
      _isCustomSelected = false;
      _controller.clear();
    });

    widget.onChanged(newValue);
  }

  void _onCustomTextChanged(String value) {
    setState(() {
      _selectedValue = value;
      _isCustomSelected = true;
    });

    widget.onChanged(value);
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
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
              ),
            ),
            value: _isCustomSelected ? null : _selectedValue,
            hint: Text(widget.hintText ?? "Select an option"),
            items: [
              ..._dropdownItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: widget.itemTextStyle ?? TextStyle(fontSize: widget.fontSize),
                  ),
                );
              }).toList(),

              // Separator inside the dropdown list
              DropdownMenuItem<String>(
                enabled: false, // Makes it unselectable
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("or", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),
              ),

              // Custom input field inside dropdown
              DropdownMenuItem<String>(
                value: _selectedValue,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Add your custom item",
                    border: InputBorder.none, // Removes the extra border
                  ),
                  onChanged: _onCustomTextChanged,
                  onTap: () {
                    setState(() {
                      _isCustomSelected = true;
                    });
                  },
                ),
              ),
            ],
            onChanged: _handleValueChanged,
            validator: widget.validator,
            dropdownColor: widget.dropdownColor,
            elevation: widget.elevation?.toInt() ?? 8,
            icon: widget.suffixIcon ?? const Icon(Icons.arrow_drop_down_circle_outlined),
            iconSize: widget.iconSize,
            isExpanded: widget.isExpanded,
          ),
        ),
      ],
    );
  }
}
