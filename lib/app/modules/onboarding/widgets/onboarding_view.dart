import 'package:flutter/material.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class OnboardingView extends StatelessWidget {
  final String img;
  final String title;
  final String description;
  const OnboardingView({
    super.key,
    required this.img,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset('assets/images/$img.png'),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: title.title(color: Colors.black),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: description.bodyMedium(center: true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
