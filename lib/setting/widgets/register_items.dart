import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/item_service.dart';
import 'package:flutter/material.dart';

class RegisterItems extends StatefulWidget {
  const RegisterItems({super.key});

  @override
  State<RegisterItems> createState() => _RegisterItemsState();
}

class _RegisterItemsState extends State<RegisterItems> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(Icons.shopping_bag, color: cs.primary),
        label: Text(
          AppStrings.addItemButton,
          style: TextStyle(color: cs.primary),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cs.primary.withAlpha(80)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          _controller.clear();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext ctx) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.onSurface.withAlpha(50),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.itemsModalTitle,
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: AppStrings.itemNameHint,
                        filled: true,
                        fillColor: cs.surfaceContainerHighest.withAlpha(80),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(AppStrings.cancelButton),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_controller.text.trim().isNotEmpty) {
                                await addItem(_controller.text.trim());
                              }
                              if (ctx.mounted) Navigator.pop(ctx);
                            },
                            child: const Text(AppStrings.saveButton),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
