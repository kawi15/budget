import 'package:budzet/app_theme.dart';
import 'package:budzet/bloc/theme/theme_cubit.dart';
import 'package:budzet/bloc/transaction/transaction_bloc.dart';
import 'package:budzet/bloc/transaction/transaction_event.dart';
import 'package:budzet/repository/category_repository.dart';
import 'package:budzet/repository/transaction_repository.dart';
import 'package:budzet/views/splash/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/budget/budget_bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'database/database.dart';
import 'views/main_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await AppDatabase().database;
  final transactionRepository = TransactionRepository(database);
  final categoryRepository = CategoryRepository(database);
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(MyApp(
    transactionRepository: transactionRepository,
    categoryRepository: categoryRepository,
  ));
}


class MyApp extends StatelessWidget {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  const MyApp({
    super.key,
    required this.transactionRepository,
    required this.categoryRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc(transactionRepository),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(categoryRepository),
        ),
        BlocProvider<BudgetBloc>(
          create: (context) => BudgetBloc(
            transactionRepository: transactionRepository,
            categoryRepository: categoryRepository,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, ThemeMode mode) {
          return MaterialApp(
            title: 'Budżet domowy',
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            themeMode: mode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('pl'),
            supportedLocales: const [
              Locale('en'), // English
              Locale('pl'), // Polish
            ],
          );
        }
      ),
    );
  }
}
