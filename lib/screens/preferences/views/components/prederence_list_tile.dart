import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class PreferencesListTile extends StatelessWidget {
  const PreferencesListTile({
    Key? key,
    required this.titleText,
    required this.subtitleTxt,
    required this.isActive,
    required this.press,
  }) : super(key: key);

  final String titleText, subtitleTxt;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.subtitle2,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        child: Text(
          subtitleTxt,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Theme.of(context).textTheme.bodyText2!.color),
        ),
      ),
      trailing: CupertinoSwitch(
        onChanged: (value) {
          press;
        },
        activeColor: primaryColor,
        value: isActive,
      ),
    );
  }
}
