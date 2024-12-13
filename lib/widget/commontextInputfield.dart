
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/size_constants.dart';

class CommonTextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? textInputType;
  final int? maxLength;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool isShowPrefixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final bool isShowSuffixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? hintTextColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? textSize;
  final double? iconSize;
  final bool required;
  final bool isDisabled;
  final bool isAteriskRequired;
  final bool showLabel;
  final int maxLines;
  final Color? textStyleColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool enableInteractiveSelection;

  const CommonTextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textInputType,
    this.maxLength,
    required this.onChanged,
    this.validator,
    this.isShowPrefixIcon = false,
    this.prefixIcon,
    this.prefix,
    this.isShowSuffixIcon = false,
    this.suffixIcon,
    this.focusNode,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.hintTextColor,
    this.height,
    this.padding,
    this.borderRadius,
    this.textSize,
    this.iconSize,
    this.required = false,
    this.isDisabled = false,
    this.isAteriskRequired = true,
    this.showLabel = true,
    this.maxLines = 1,
    this.textStyleColor,
    this.fontWeight,
    this.fontSize,
    this.enableInteractiveSelection = true,
  });

  @override
  State<CommonTextInputField> createState() => _CommonTextInputFieldState();
}

class _CommonTextInputFieldState extends State<CommonTextInputField> {
  late FocusNode _focusNode;
  bool isOnFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      isOnFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? SizeConstant.onboardingTextInputHeight,
      padding: widget.padding ??
          EdgeInsets.symmetric(
            horizontal: SizeConstant.getHeightWithScreen(15),
          ),
      decoration: BoxDecoration(
        color: widget.fillColor ?? ColorConstant.white,
        border: Border.all(
          color: widget.borderColor ?? ColorConstant.grey14,
          width: SizeConstant.getHeightWithScreen(1),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            widget.borderRadius ?? SizeConstant.getHeightWithScreen(10),
          ),
        ),
      ),
      child: Center(
        child: TextFormField(
          maxLines: widget.maxLines,
          focusNode: _focusNode,
          enabled: !widget.isDisabled,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          // maxLength: widget.maxLength,
          contextMenuBuilder: (context, editableTextState) {
            return widget.enableInteractiveSelection
                ? AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            )
                : Container(); // Return an empty container to remove the context menu
          },
          onChanged: (text) {
            widget.onChanged(text);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          },
          keyboardType: widget.textInputType,
          controller: widget.controller,
          style: TextStyle(
            color: widget.textStyleColor ?? ColorConstant.black3,
            fontSize:
            widget.fontSize ?? widget.textSize ?? SizeConstant.smallFont,
            fontWeight: widget.fontWeight ?? FontWeight.w400,
          ),

          maxLength: widget.maxLength,

          decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            prefix: widget.prefix,
            counterText: "",
            alignLabelWithHint: true,
            label: widget.showLabel == false &&
                isOnFocus == false &&
                widget.controller.text.isEmpty
                ? Row(
              children: [
                Text(widget.hintText),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConstant.getHeightWithScreen(1.0),
                  ),
                ),
                widget.isAteriskRequired
                    ? const Text('*', style: TextStyle(color: Colors.red))
                    : const SizedBox(),
              ],
            )
                : widget.showLabel
                ? Row(
              children: [
                Text(widget.hintText),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConstant.getHeightWithScreen(1.0),
                  ),
                ),
                widget.isAteriskRequired
                    ? const Text('*',
                    style: TextStyle(color: Colors.red))
                    : const SizedBox(),
              ],
            )
                : null,
            contentPadding: widget.contentPadding ??
                EdgeInsets.only(
                  left: SizeConstant.getHeightWithScreen(0),
                  top: isOnFocus || widget.controller.text.isNotEmpty
                      ? SizeConstant.getHeightWithScreen(11)
                      : SizeConstant.getHeightWithScreen(17),
                  bottom: isOnFocus || widget.controller.text.isNotEmpty
                      ? SizeConstant.getHeightWithScreen(9)
                      : SizeConstant.getHeightWithScreen(21),
                ),
            labelStyle: TextStyle(
              color: widget.hintTextColor ?? ColorConstant.textFieldHintColor,
              fontSize: widget.textSize ?? SizeConstant.smallFont,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            floatingLabelStyle: TextStyle(
              color: ColorConstant.textFieldHintColor,
              fontSize: SizeConstant.smallFont,
            ),
          ),
        ),
      ),
    );
  }
}
