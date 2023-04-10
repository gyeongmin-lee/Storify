import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

enum ButtonSize { regular, small }

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.size = ButtonSize.regular,
    this.borderColor = CustomColors.secondaryTextColor,
    this.backgroundColor = Colors.transparent,
    this.textColor = CustomColors.secondaryTextColor,
    this.disabled = false,
    this.regularLetterSpacing = 1.0,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String buttonText;
  final ButtonSize size;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final bool disabled;
  final double regularLetterSpacing;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 36.0,
      height: 10.0,
      child: TextButton(
        onPressed: !disabled ? onPressed : null,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(0.5),
          padding: size == ButtonSize.regular
              ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0)
              : EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                  color: disabled ? borderColor.withOpacity(0.5) : borderColor,
                  width: size == ButtonSize.regular ? 2.0 : 1.0)),
        ),
        child: Text(buttonText,
            style: size == ButtonSize.regular
                ? TextStyles.secondary.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: regularLetterSpacing,
                    color: textColor)
                : TextStyles.smallButtonText.copyWith(color: textColor)),
      ),
    );
  }
}
