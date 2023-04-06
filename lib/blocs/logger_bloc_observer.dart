import 'package:bloc/bloc.dart';
import 'package:storify/blocs/blocs.dart';

class LoggerBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (bloc.runtimeType != CurrentPlaybackBloc)
      print('${bloc.runtimeType} $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
