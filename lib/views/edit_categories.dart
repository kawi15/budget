import 'package:flutter/material.dart';

class EditCategories extends StatefulWidget {
  const EditCategories({Key? key}) : super(key: key);

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {

  static List<String> categories = ['Osobiste', 'Jedzenie', 'Zdrowie', 'Dom', 'Podróże'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj kategorie'),
      ),
      body: ReorderableListView.builder(
        itemCount: categories.length,
        buildDefaultDragHandles: true,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key(categories[index].toString()),
            tileColor: index.isOdd ? Colors.blueAccent : Colors.lightBlueAccent,
            title: Text(categories[index]),
            trailing: const Icon(Icons.drag_handle),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = categories.removeAt(oldIndex);
            categories.insert(newIndex, item);
          });
        },
      )
    );
  }
}
