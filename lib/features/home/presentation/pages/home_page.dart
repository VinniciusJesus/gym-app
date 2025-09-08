import 'package:flutter/material.dart';
import 'package:gym/core/app_state.dart';
import 'package:provider/provider.dart';

import '../../../../core/shared/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Column(
        children: [
          Container(),

          TextButton(
            onPressed: () {
              provider.logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontSize: 13.5),
            ),
            child: Text("Sair"),
          ),
        ],
      ),
    );
  }
}
