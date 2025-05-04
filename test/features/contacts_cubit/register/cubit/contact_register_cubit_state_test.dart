import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts_cubit/register/cubit/contact_register_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() { 

    //declaração
  late ContactsRepository repository;
  late ContactRegisterCubit cubit;
  late List<ContactModel> contacts;

  //preparação
  setUp((){
    repository = MockContactsRepository();
    cubit = ContactRegisterCubit(contactsRepository: repository);
    contacts = [
      ContactModel(name: 'Gustavo Dias2', email: 'gustavf@gmail.com'),
      ContactModel(name: 'Gustavo Dias Pessoal', email: 'gustavf@gmail.noia'),
    ];
    registerFallbackValue(contacts.first);
  });

  //execução
  blocTest<ContactRegisterCubit, ContactRegisterCubitState>(
    'Deve registrar o contato', 
    build: () => cubit,
    act: (cubit) => cubit.createModel(
      id: 0,
      name: 'name',
      email: 'email',
    ),
    setUp: () {
      when(() => repository.create(any()),).thenAnswer((_) async => {});
      when(() => repository.findAll()).thenAnswer((_) async => contacts);
    },
    expect: () => [
      ContactRegisterCubitState.loading(),
      ContactRegisterCubitState.success(),
      ContactRegisterCubitState.loading(),
      ContactRegisterCubitState.data(contacts: contacts),
      // ContactRegisterCubitState.error(error: 'Erro ao buscar contatos')
    ]
  );

  blocTest<ContactRegisterCubit, ContactRegisterCubitState>(
    'Deve retornar erro ao registrar o contato', 
    build: () => cubit,
    act: (cubit) => cubit.createModel(
      id: 0,
      name: 'name',
      email: 'email',
    ),
    setUp: () {
      when(() => repository.create(any()),).thenThrow(Exception());
    },
    expect: () => [
      ContactRegisterCubitState.loading(),
      ContactRegisterCubitState.error(error: 'Erro ao registrar contato'),
    ]
  );

}