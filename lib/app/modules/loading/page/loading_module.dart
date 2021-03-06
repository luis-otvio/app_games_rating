import 'package:app_games_rating/app/modules/loading/page/loading_store.dart';
import 'package:app_games_rating/app/modules/loading/page/loading_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoadingModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoadingStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => LoadingPage()),
  ];
}
