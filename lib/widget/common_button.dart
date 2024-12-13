import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/size_constants.dart';

class CommonButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String label;
  final double? btnHeight;
  final double? btnWidth;
  final double? borderRadius;
  final double? textSize;
  final FontWeight? weight;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final String? fontFamily;

  const CommonButton(
      {super.key,
        required this.onTap,
        required this.label,
        this.btnHeight,
        this.btnWidth = double.maxFinite,
        this.borderRadius,
        this.textSize,
        this.weight,
        this.textColor,
        this.bgColor,
        this.borderColor,
        this.fontFamily});

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(true);

  void _handleButtonClick() {
    if (_isButtonEnabled.value) {
      _isButtonEnabled.value = false;
      widget.onTap!();

      Future.delayed(const Duration(milliseconds: 500), () {
        _isButtonEnabled.value = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isButtonEnabled,
      builder: (context, isEnabled, child) {
        return InkWell(
          highlightColor: widget.bgColor ?? ColorConstant.primaryColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 9),
          onTap: isEnabled ? _handleButtonClick : null,
          child: Container(
            width: widget.btnWidth,
            height: widget.btnHeight ?? SizeConstant.btnHeight,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: widget.borderColor ?? Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 9),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.bgColor ?? ColorConstant.primaryColor,
                disabledBackgroundColor: ColorConstant.bDisabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 9),
                ),
              ),
              onPressed: widget.onTap,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.textSize ?? SizeConstant.mediumFont,
                  fontWeight: widget.weight ?? FontWeight.w500,
                  color: widget.textColor ?? ColorConstant.white,
                  fontFamily: widget.fontFamily,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
