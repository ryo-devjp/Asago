import 'package:flutter/material.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

class RegisterTask extends StatefulWidget {
  const RegisterTask({super.key});

  @override
  State<RegisterTask> createState() => _RegisterTaskState();
}

class _RegisterTaskState extends State<RegisterTask> {
  late TextEditingController _controller;
  int _duration = 10;

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
        icon: Icon(Icons.add_rounded, color: cs.primary),
        label: Text(
          AppStrings.registerTaskButton,
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
          _duration = 10;
          final wheelController = FixedExtentScrollController(initialItem: 9);
          String? errorText;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext ctx) {
              return StatefulBuilder(
                builder: (BuildContext ctx, StateSetter setModalState) {
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
                          AppStrings.newTaskModalTitle,
                          style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _controller,
                          autofocus: true,
                          decoration: InputDecoration(
                            errorText: errorText,
                            hintText: AppStrings.taskNameHint,
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
                          onChanged: (_) {
                            if (errorText != null) {
                              setModalState(() => errorText = null);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppStrings.taskDurationHint,
                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: cs.primaryContainer.withAlpha(100),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              ListWheelScrollView.useDelegate(
                                controller: wheelController,
                                itemExtent: 44,
                                perspective: 0.006,
                                diameterRatio: 1.4,
                                physics: const FixedExtentScrollPhysics(),
                                overAndUnderCenterOpacity: 0.4,
                                onSelectedItemChanged: (index) {
                                  setModalState(() => _duration = index + 1);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 120,
                                  builder: (context, index) {
                                    return Center(
                                      child: Text(
                                        '${index + 1}分',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 70,
                                child: IgnorePointer(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Theme.of(ctx).colorScheme.surface,
                                          Theme.of(
                                            ctx,
                                          ).colorScheme.surface.withAlpha(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 70,
                                child: IgnorePointer(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Theme.of(ctx).colorScheme.surface,
                                          Theme.of(
                                            ctx,
                                          ).colorScheme.surface.withAlpha(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
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
                                  final taskName = _controller.text.trim();

                                  if (taskName.isEmpty) {
                                    setModalState(() {
                                      errorText =
                                          AppStrings.taskNameRequiredError;
                                    });
                                    return;
                                  }

                                  await addTask(
                                    taskName,
                                    _duration,
                                  );

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
          ).then((_) => wheelController.dispose());
        },
      ),
    );
  }
}
