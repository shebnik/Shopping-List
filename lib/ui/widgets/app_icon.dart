import 'package:flutter/material.dart';
import 'package:shoppinglist/services/storage_service.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder<String>(
        future: StorageService.getIcon(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? Image.network(
                    snapshot.data!,
                    fit: BoxFit.scaleDown,
                  )
                : const SizedBox(),
      ),
    );
  }
}
