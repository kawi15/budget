import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  final _formKey = GlobalKey<FormState>();
  static const List<String> dropdownList = ['Osobiste', 'Jedzenie', 'Zdrowie'];
  bool autosaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj transakcje'),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.add)
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              top: 16,
              left: 12,
              right: 12,
              bottom: 16
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Koszt',
                      border: OutlineInputBorder()
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                        labelText: 'Data',
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: DropdownButton2(
                        items: dropdownList.map((String val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                        onChanged: (String? val) {

                        },
                        isExpanded: true,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Opis',
                        border: OutlineInputBorder()
                    ),
                  ),
                  Row(
                    children: [
                      Switch(value: autosaving, onChanged: (value) {
                        setState(() {
                          autosaving = value;
                        });
                      }),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Autooszczędzanie',
                              border: OutlineInputBorder()
                          ),
                          enabled: autosaving,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
