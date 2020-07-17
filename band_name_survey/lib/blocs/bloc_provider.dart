import 'package:flutter/material.dart';

Type _typeOf<T>() => T;

abstract class BlocBase
{
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget
{
  final T bloc;
  final Widget child;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc
  }) : super(key: key);

  _BlocProviderState<T> createState()=>_BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context)
  {
    Type type = _typeOf<_BlockProviderInherited<T>>();
    _BlockProviderInherited<T> provider = (context.ancestorInheritedElementForWidgetOfExactType(type)?.widget as _BlockProviderInherited<T>);
    return provider?.bloc;
  }

}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>>
{

  dispose()
  {
    widget.bloc?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context)
  {
    return _BlockProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlockProviderInherited<T extends BlocBase> extends InheritedWidget
{
  final T bloc;

  _BlockProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
