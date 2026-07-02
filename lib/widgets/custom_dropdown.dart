import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?> onSelected;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.entries,
    required this.onSelected,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        return DropdownMenu<T>(
          initialSelection: field.value,
          dropdownMenuEntries: entries,
          width: double.infinity,
          leadingIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          label: Text(label),

          errorText: field.errorText,

          onSelected: (value) {
            field.didChange(value);
            onSelected(value);
          },
        );
      },
    );
  }
}