import 'package:flutter/material.dart';

Future<String?> showEditNameDialog(
  BuildContext context, {
  required String currentName,
}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (context) => _EditNameDialog(currentName: currentName),
  );
  return name;
}

class _EditNameDialog extends StatefulWidget {
  const _EditNameDialog({required this.currentName});

  final String currentName;

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final canSave = _controller.text.trim().isNotEmpty;
    return AlertDialog(
      backgroundColor: palette.surface,
      title: const Text('Edit name'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 40,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Display name'),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: canSave
              ? () => Navigator.of(context).pop(_controller.text.trim())
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}