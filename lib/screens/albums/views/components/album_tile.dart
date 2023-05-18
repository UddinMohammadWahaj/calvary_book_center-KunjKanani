import 'package:bookcenter/constants.dart';
import 'package:flutter/material.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile({
    super.key,
    required this.albumLogo,
    required this.onPressed,
    required this.index,
    required this.isPurchased,
  });

  final String albumLogo;
  final VoidCallback onPressed;
  final int index;
  final bool isPurchased;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: albumLogo,
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
                child: Image.network(
                  albumLogo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isPurchased)
              Positioned(
                right: defaultPadding / 2,
                top: defaultPadding / 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
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
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
