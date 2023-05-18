import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class CupertinoSwitchDividedListTile extends StatelessWidget {
  const CupertinoSwitchDividedListTile({
    Key? key,
    required this.title,
    this.subTitle,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  final String title;
  final String? subTitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          subtitle: subTitle != null
              ? Padding(
                  padding: const EdgeInsets.only(top: defaultPadding / 2),
                  child: Text(
                    subTitle!,
                    style: Theme.of(context).textTheme.caption,
                  ),
                )
              : null,
          trailing: CupertinoSwitch(
            activeColor: primaryColor,
            value: value,
            onChanged: onChanged,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
