import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const MenuCard({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text("Selengkapnya",
                style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
