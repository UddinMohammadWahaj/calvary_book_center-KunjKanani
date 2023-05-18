import 'package:bookcenter/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SermonTile extends StatelessWidget {
  const SermonTile({
    super.key,
    required this.sermonLogo,
    required this.onPressed,
    required this.isPurchased,
  });

  final String sermonLogo;
  final VoidCallback onPressed;
  final bool isPurchased;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: sermonLogo,
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: sermonLogo,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            if (isPurchased)
              Positioned(
                right: defaultPadding / 2,
                top: defaultPadding / 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                  ),
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(defaultBorderRadious),
                    ),
                  ),
                  child: const Text(
                    'Purchased',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
