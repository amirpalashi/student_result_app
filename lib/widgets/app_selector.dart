import 'package:flutter/material.dart';

class AppSelector<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T> onChanged;
  final String? Function(T?)? validator;

  const AppSelector({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            final selected = await showModalBottomSheet<T>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              builder: (_) => _SelectorSheet<T>(
                title: label,
                items: items,
                selected: field.value,
                itemLabel: itemLabel,
              ),
            );

            if (selected != null) {
              field.didChange(selected);
              onChanged(selected);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              errorText: field.errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(width: 2, color: Colors.blue),
              ),
            ),
            child: Text(
              field.value == null
                  ? "Select $label"
                  : itemLabel(field.value as T),
              style: TextStyle(
                fontSize: 16,
                color: field.value == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectorSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selected;
  final String Function(T) itemLabel;

  const _SelectorSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.itemLabel,
  });

  @override
  State<_SelectorSheet<T>> createState() => _SelectorSheetState<T>();
}

class _SelectorSheetState<T> extends State<_SelectorSheet<T>> {
  late List<T> filtered;

  @override
  void initState() {
    super.initState();
    filtered = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    filtered = widget.items.where((e) {
                      return widget
                          .itemLabel(e)
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final item = filtered[index];

                  final selected = item == widget.selected;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Material(
                      color: selected ? Colors.blue.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        leading: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            selected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            key: ValueKey(selected),
                            color: selected ? Colors.blue : Colors.grey,
                          ),
                        ),
                        title: Text(
                          widget.itemLabel(item),
                          style: TextStyle(
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                        trailing: selected
                            ? const Icon(Icons.done, color: Colors.blue)
                            : null,
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
