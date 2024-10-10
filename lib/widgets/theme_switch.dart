import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme/theme_cubit.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ),
      ],
    );
  }
}
