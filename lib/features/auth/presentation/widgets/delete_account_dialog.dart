import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/errors/auth_exception.dart';
import '../providers/auth_controller.dart';
import 'auth_password_field.dart';

class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  ConsumerState<DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _deleting = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (_deleting) return;
    if (_password.text.isEmpty) {
      setState(() => _error = 'Enter your password to confirm.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _deleting = true;
      _error = null;
    });
    final success = await ref
        .read(authControllerProvider.notifier)
        .deleteAccount(_password.text);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _deleting = false;
      final error = ref.read(authControllerProvider).error;
      _error = error is AuthException
          ? error.message
          : 'Something went wrong. Please try again.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return AlertDialog(
      backgroundColor: palette.surface2,
      title: Text(
        'Delete account?',
        style: AppTextStyles.body(16, weight: FontWeight.w600).copyWith(
          color: palette.text,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'This permanently deletes your account and all of your data. '
            'Enter your password to continue.',
            style: AppTextStyles.body(13).copyWith(color: palette.textSec),
          ),
          const SizedBox(height: 16),
          AuthPasswordField(
            controller: _password,
            focusNode: _passwordFocus,
            obscure: _obscure,
            onToggle: () => setState(() => _obscure = !_obscure),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: AppTextStyles.caption.copyWith(color: AppColors.danger),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: AppTextStyles.body(13, weight: FontWeight.w600).copyWith(
              color: palette.textSec,
            ),
          ),
        ),
        TextButton(
          onPressed: _deleting ? null : _delete,
          child: Text(
            'Delete',
            style: AppTextStyles.body(13, weight: FontWeight.w600).copyWith(
              color: AppColors.danger,
            ),
          ),
        ),
      ],
    );
  }
}