import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:budzet/views/add_transaction.dart';
import 'package:budzet/bloc/theme/theme_cubit.dart';
import 'package:budzet/views/budget.dart';
import 'package:budzet/views/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Październik 2024'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.greenAccent
              ),
              margin: EdgeInsets.zero,
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedToggleSwitch<ThemeMode>.rolling(
                    current: context.watch<ThemeCubit>().state,
                    onChanged: (value) => context.read<ThemeCubit>().changeTheme(value),
                    values: const [
                      ThemeMode.light,
                      ThemeMode.dark
                    ],
                    iconList: const [
                      Icon(Icons.light_mode, color: Colors.white),
                      Icon(Icons.dark_mode, color: Colors.white)
                    ],
                    borderWidth: 0,
                    styleBuilder: (i) => ToggleStyle(indicatorColor: i == ThemeMode.light ? Colors.greenAccent : Colors.deepPurple),
                    style: ToggleStyle(
                      backgroundColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(16),
                      //indicatorBorderRadius: BorderRadius.circular(64),
                      //indicatorColor: Colors.black,
                    ),
                ),
              ],
            )
          ]
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            Budget(),
            TransactionHistory()
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                customBorder: const CircleBorder(),
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _currentIndex = 0;
                  _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Icon(Icons.home_outlined, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                      const Text("Home")
                    ]
                )
            ),
            InkWell(
                customBorder: const CircleBorder(),
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _currentIndex = 1;
                  _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Icon(Icons.multiline_chart, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                      const Text("Stats")
                    ]
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransaction()));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
    );
  }
}
