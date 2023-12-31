import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kima/firebase_options.dart';
import 'package:kima/src/app.dart';
import 'package:kima/src/app_bloc_observer.dart';
import 'package:kima/src/screens/marketplace/classifieds_description_screen.dart';
import 'package:kima/src/utils/enums.dart';

void main() async {
  // This makes sure that the widgets are initialized before the app runs.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'kima-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set the app's bloc observer to AppBlocObserver.
  Bloc.observer = AppBlocObserver();

  runApp(const App(
    flavor: AppFlavorsEnum.dev,
  ));


  ;
}
