import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
 
    //declaração
  late ContactsRepository repository;
  late ContactListCubit cubit;
  late List<ContactModel> contacts;

  //preparação
  setUp((){
    repository = MockContactsRepository();
    cubit = ContactListCubit(repository: repository);
    contacts = [
      ContactModel(name: 'Gustavo Dias2', email: 'gustavf@gmail.com'),
      ContactModel(name: 'Gustavo Dias Pessoal', email: 'gustavf@gmail.noia'),
    ];
    registerFallbackValue(contacts.first);
  });

  //execução
  blocTest<ContactListCubit, ContactListCubitState>(
    'Deve buscar os contatos', 
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    setUp: () {
      when(() => repository.findAll(),).thenAnswer((_) async => contacts);
    },
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.data(contacts: contacts),
    ]
  );

  blocTest<ContactListCubit, ContactListCubitState>(
    'Deve retornar erro ao buscar os contatos', 
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    setUp: () {
      when(() => repository.findAll(),).thenThrow(Exception());
    },
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.error(error: 'Erro ao buscar contatos'),
    ]
  );

  blocTest<ContactListCubit, ContactListCubitState>(
    'Deve deletar o contato', 
    build: () => cubit,
    act: (cubit) => cubit.deleteByModel(
        ContactModel(
          name: 'name', 
          email: 'email'
        )
    ),
    setUp: () {
      when(() => repository.delete(any()),).thenAnswer((invocation) async {return true;});
    },
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.success(),
      // ContactListCubitState.error(error: 'Erro ao deletar contato'),
    ]
  );

  blocTest<ContactListCubit, ContactListCubitState>(
    'Deve retornar erro ao deletar o contato', 
    build: () => cubit,
    act: (cubit) => cubit.deleteByModel(
        ContactModel(
          name: 'name', 
          email: 'email'
        )
    ),
    setUp: () {
      when(() => repository.delete(any()),).thenThrow(Exception());
    },
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.error(error: 'Erro ao deletar contato'),
    ]
  );
}