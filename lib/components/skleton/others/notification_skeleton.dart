import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:flutter/material.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Stack(
            alignment: Alignment.topRight,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    Theme.of(context).iconTheme.color!.withOpacity(0.04),
              ),
              // if (!isRead)
              //   const ChatActiveDot(
              //     dotColor: Color(0xFFE5614F),
              //   ),
            ],
          ),
          title: const Skeleton(
            width: 200,
            height: 16,
          ),
          subtitle: const Align(
            alignment: Alignment.centerLeft,
            child: Skeleton(width: 70, height: 14),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
