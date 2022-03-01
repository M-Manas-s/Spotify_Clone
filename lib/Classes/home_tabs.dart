import 'package:flutter/cupertino.dart';

class HomeTab with ChangeNotifier{
  int tab = 0;
  void change(int i){
    tab = i;
    notifyListeners();
  }
}