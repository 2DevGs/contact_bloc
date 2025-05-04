
part of 'example_bloc.dart';

@immutable
abstract class ExampleState {
  
}

class ExampleStateInitial extends ExampleState {

}

class ExampleStateData extends ExampleState {
  final List<String> names;
  // final List<String> newNames;

  ExampleStateData({
    required this.names,
    // required this.newNames,
  });
}
