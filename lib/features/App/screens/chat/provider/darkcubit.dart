import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeModeEnum { light, dark }

class ThemeCubit extends Cubit<ThemeModeEnum> {
  ThemeCubit() : super(ThemeModeEnum.light);

  void toggleTheme() {
    emit(state == ThemeModeEnum.light ? ThemeModeEnum.dark : ThemeModeEnum.light);
  }
}