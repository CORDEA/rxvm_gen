import 'package:rxdart/rxdart.dart';
import 'package:rxvm_gen/annotations.dart';

part 'main_view_model.g.dart';

@RxViewModel()
class MainViewModel {
  @VisibleSubject()
  final BehaviorSubject<String> _title = BehaviorSubject.seeded('');

  @VisibleSubject()
  final BehaviorSubject<String?> _body = BehaviorSubject.seeded(null);

  @VisibleSubject()
  final BehaviorSubject<int> _count = BehaviorSubject.seeded(0);

  void dispose() {
    _dispose();
  }
}
