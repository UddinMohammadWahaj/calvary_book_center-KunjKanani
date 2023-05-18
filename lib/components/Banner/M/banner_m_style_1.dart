import 'package:flutter/material.dart';
import 'banner_m.dart';

import '../../../constants.dart';

class BannerMStyle1 extends StatelessWidget {
  const BannerMStyle1({
    Key? key,
    this.image = "",
    required this.text,
    required this.press,
    this.subTitle = '',
  }) : super(key: key);
  final String? image;
  final String text, subTitle;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerM(
      image: image ?? '',
      press: press,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  text,
                  style: const TextStyle(
                    fontFamily: grandisExtendedFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                subTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subTitle.isNotEmpty)
                const SizedBox(
                  width: 64,
                  child: Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ],
    );
  }
}
