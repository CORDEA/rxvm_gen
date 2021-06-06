// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_view_model.dart';

// **************************************************************************
// RxVmGenerator
// **************************************************************************

extension MainViewModelExt on MainViewModel {
  ValueStream<String> get title => _title;
  ValueStream<String?> get body => _body;
  ValueStream<int> get count => _count;
  void _dispose() {
    _title.close();
    _body.close();
    _count.close();
  }
}
