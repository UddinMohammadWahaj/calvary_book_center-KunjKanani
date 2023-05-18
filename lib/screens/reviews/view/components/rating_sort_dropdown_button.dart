import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RatingSortDropdownButton extends StatelessWidget {
  const RatingSortDropdownButton({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: SvgPicture.asset("assets/icons/miniDown.svg",
          color: Theme.of(context).iconTheme.color),
      style: Theme.of(context).textTheme.subtitle2,
      underline: const SizedBox(),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
