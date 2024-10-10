import 'package:flutter/material.dart';

import '../views/add_transaction.dart';

class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Dodaj transakcję',
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransaction()));
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
