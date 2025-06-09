import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 75,
            child: Image.asset(
              'assets/images/logo_rinema.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
