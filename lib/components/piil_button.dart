import 'package:bookcenter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    Key? key,
    required this.text,
    this.svgSrc,
    required this.isActive,
    required this.press,
    this.margin,
  }) : super(key: key);

  final String text;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        margin: margin,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              svgSrc!.contains('svg')
                  ? SvgPicture.asset(
                      svgSrc!,
                      height: 20,
                      color: isActive
                          ? Colors.white
                          : Theme.of(context).iconTheme.color,
                    )
                  : Image.asset(
                      svgSrc!,
                      height: 20,
                    ),
            if (svgSrc != null) const SizedBox(width: defaultPadding / 2),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
