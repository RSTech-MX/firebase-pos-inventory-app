import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          tooltip: 'Notificaciones',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const Positioned(
          top: 10,
          right: 10,
          child: CircleAvatar(radius: 4, backgroundColor: Color(0xFFED765E)),
        ),
      ],
    );
  }
}
