import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';

class HeroAddButton extends StatelessWidget {
  const HeroAddButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Material(
      color: const Color(0x1FFFFFFF),
      borderRadius: BorderRadius.circular(AppConstants.radiusButton),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusButton),
        child: SizedBox(
          width: sizes.iconActionSize,
          height: sizes.iconActionSize,
          child: Icon(Icons.add, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}
