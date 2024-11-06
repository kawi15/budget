import 'package:flutter/material.dart';


class Budget extends StatefulWidget {
  const Budget({Key? key, required this.month}) : super(key: key);

  final DateTime month;

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {

  static const List<String> categories = ['Osobiste', 'Jedzenie', 'Zdrowie', 'Dom', 'Podróże'];
  static const List<dynamic> values = [123, 343.15, 33, 81, 0];
  static const List<dynamic> valuesTwo = [0, 12.15, 33.2, 17, 130];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8
            ),
            itemCount: categories.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {

                },
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.greenAccent
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        categories[index]
                      ),
                      Text(
                        widget.month.month != DateTime.now().month
                            ? '${values[index]} zł'
                            : '${valuesTwo[index]} zł'
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
