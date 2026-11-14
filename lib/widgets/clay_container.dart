import 'package:flutter/material.dart';
import '../theme/clay_theme.dart';

/// Extruded tactile clay container with dual-source shadows (light top-left, shadow bottom-right).
class ClayCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double elevation;
  final Gradient? gradient;

  const ClayCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
    this.elevation = 7.0,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? ClayColors.surfaceElevated) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: ClayShadows.extruded(offset: elevation, blur: elevation * 2.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.0,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }
    return content;
  }
}

/// Circular or rounded clay icon button with micro press feedback.
class ClayIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;
  final String? tooltip;

  const ClayIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 46.0,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 999.0,
    this.tooltip,
  });

  @override
  State<ClayIconButton> createState() => _ClayIconButtonState();
}

class _ClayIconButtonState extends State<ClayIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? ClayColors.surfaceContainerLow;

    Widget button = GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _isPressed
                ? ClayShadows.recessed
                : ClayShadows.subtle(offset: 4, blur: 8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: widget.icon,
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

/// Tactile Checkbox: Unchecked is recessed slot; checked is extruded mint bead.
class ClayCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  const ClayCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? ClayColors.mintButton : ClayColors.surfaceContainerLow,
          boxShadow: value
              ? [
                  BoxShadow(
                    color: ClayColors.mintShadow.withValues(alpha: 0.9),
                    offset: const Offset(3, 3),
                    blurRadius: 7,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 7,
                  ),
                ]
              : [
                  BoxShadow(
                    color: ClayColors.shadowDark.withValues(alpha: 0.85),
                    offset: const Offset(2.5, 2.5),
                    blurRadius: 5,
                    spreadRadius: -0.5,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2.5, -2.5),
                    blurRadius: 5,
                    spreadRadius: -0.5,
                  ),
                ],
          border: Border.all(
            color: value ? Colors.white : Colors.white.withValues(alpha: 0.7),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: value
            ? const Icon(
                Icons.check_rounded,
                size: 16,
                color: ClayColors.mintText,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

/// Category and status pill badge (Work, Important, Personal, Completed, etc.).
class ClayPill extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsetsGeometry padding;

  const ClayPill({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
  });

  factory ClayPill.work({required String label, VoidCallback? onTap, bool isSelected = false}) =>
      ClayPill(
        label: label,
        backgroundColor: ClayColors.blueSurface,
        textColor: ClayColors.blueText,
        onTap: onTap,
        isSelected: isSelected,
      );

  factory ClayPill.important({required String label, VoidCallback? onTap, bool isSelected = false}) =>
      ClayPill(
        label: label,
        backgroundColor: ClayColors.peachSurface,
        textColor: ClayColors.peachText,
        onTap: onTap,
        isSelected: isSelected,
      );

  factory ClayPill.personal({required String label, VoidCallback? onTap, bool isSelected = false}) =>
      ClayPill(
        label: label,
        backgroundColor: ClayColors.lavenderSurface,
        textColor: ClayColors.lavenderText,
        onTap: onTap,
        isSelected: isSelected,
      );

  factory ClayPill.done({required String label, VoidCallback? onTap, bool isSelected = false}) =>
      ClayPill(
        label: label,
        backgroundColor: ClayColors.mintSurface,
        textColor: ClayColors.mintText,
        icon: Icons.check,
        onTap: onTap,
        isSelected: isSelected,
      );

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: ClayColors.shadowDark.withValues(alpha: 0.65),
            offset: const Offset(2.5, 2.5),
            blurRadius: 6,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-2.5, -2.5),
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}

/// Primary or secondary tactile Clay Button.
class ClayButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final double height;
  final bool isLoading;

  const ClayButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.height = 52.0,
    this.isLoading = false,
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.isPrimary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [ClayColors.primaryContainer, ClayColors.primaryGradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isPrimary ? null : ClayColors.surfaceContainerLow,
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: (isPrimary ? const Color(0xFF7084E6) : ClayColors.shadowDark).withValues(alpha: 0.9),
                      offset: const Offset(3, 3),
                      blurRadius: 6,
                    ),
                  ]
                : (isPrimary ? ClayShadows.buttonPrimary : ClayShadows.subtle()),
            border: Border.all(
              color: Colors.white.withValues(alpha: isPrimary ? 0.6 : 0.8),
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: widget.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: 20,
                        color: isPrimary ? Colors.white : ClayColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isPrimary ? Colors.white : ClayColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Carved / Recessed clay input field.
class ClayTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const ClayTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ClayColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 999),
        boxShadow: ClayShadows.recessed,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: maxLines > 1 ? 12 : 2,
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            Padding(
              padding: EdgeInsets.only(top: maxLines > 1 ? 4 : 0, right: 10),
              child: Icon(
                prefixIcon,
                size: 20,
                color: ClayColors.textSecondary,
              ),
            ),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              maxLines: maxLines,
              onChanged: onChanged,
              style: const TextStyle(
                color: ClayColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: ClayColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: maxLines == 1,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }
}
