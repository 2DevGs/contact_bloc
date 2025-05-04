
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState>{

  ExampleBloc() : super(ExampleStateInitial()){
    on<ExampleFindNameEvent>(_findNames);
    on<ExampleRemoveNameEvent>(_removeName);
    on<ExampleAddNameEvent>(_addName);
  }

  FutureOr<void> _addName(
    ExampleAddNameEvent event, 
    Emitter<ExampleState> emit) 
    {

      final stateExampleAdd = state;

      if(stateExampleAdd is ExampleStateData){
      final names = [...stateExampleAdd.names];
      names.add('Desafio Completo');
      emit(ExampleStateData(names: names));

      }
     
    }

  FutureOr<void> _removeName(
    ExampleRemoveNameEvent event, 
    Emitter<ExampleState> emit,) 
    {

      final stateExample = state;

      if(stateExample is ExampleStateData) {
        final names = [...stateExample.names];
        names.retainWhere((element) => element != event.name);
        emit(ExampleStateData(names: names));
      }
    }

  FutureOr<void> _findNames(
    ExampleFindNameEvent event, 
    Emitter<ExampleState> emit) 
    async {
      final names = [
        'Rodrigo Rahman', 
        'Gustavo Dias',
        'Academia do Flutter', 
        ' Flutter', 
        'Dart', 
        'Flutter Bloc',
      ];
      await Future.delayed(const Duration(seconds: 4));
      emit(ExampleStateData(names: names));
    }
    

}