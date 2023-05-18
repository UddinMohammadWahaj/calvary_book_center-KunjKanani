import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class HelpLine extends StatelessWidget {
  const HelpLine({
    Key? key,
    required this.number,
  }) : super(key: key);
  final String number;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Need help with anything?",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodyText2!.color,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        child: Text(
          "Call $number",
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
      trailing: CircleAvatar(
        radius: 24,
        backgroundColor: primaryColor,
        child: SvgPicture.asset(
          "assets/icons/Call.svg",
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}