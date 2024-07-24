import 'package:flutter/material.dart';

class ActionsView extends StatelessWidget {
  const ActionsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Действия",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                label: const Text("Очистить камеру"),
                icon: const Icon(Icons.cleaning_services),
                onPressed: () {},
              ),
              ElevatedButton.icon(
                label: const Text("Сигналить"),
                icon: const Icon(Icons.volume_up),
                onPressed: () {},
              ),
              ElevatedButton.icon(
                label: const Text("Включить фары"),
                icon: const Icon(Icons.light_mode),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
