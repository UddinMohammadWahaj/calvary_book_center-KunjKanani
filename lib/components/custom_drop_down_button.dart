import 'package:bookcenter/constants.dart';
import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    Key? key,
    required this.items,
    this.value,
    required this.onChanged,
    this.hint,
  }) : super(key: key);

  final List<DropdownMenuItem>? items;
  final dynamic value;
  final ValueChanged? onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGreyColor,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2.2,
      ),
      child: DropdownButton(
        items: items,
        onChanged: onChanged,
        hint: hint != null ? Text(hint!) : null,
        icon: Container(),
        elevation: 0,
        value: value,
        isExpanded: true,
        underline: Container(),
      ),
    );
  }
}
