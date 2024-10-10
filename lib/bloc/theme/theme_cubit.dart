import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['theme'] as int];
  }

  void changeTheme(ThemeMode mode) {
    emit(mode);
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      'theme': state.index
    };
  }
}