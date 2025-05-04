import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts_cubit/update/cubit/contact_update_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {

    //declaração
  late ContactsRepository repository;
  late ContactUpdateCubit cubit;
  late List<ContactModel> contacts;

  //preparação
  setUp((){
    repository = MockContactsRepository();
    cubit = ContactUpdateCubit(contactsRepository: repository);
    contacts = [
      ContactModel(name: 'Gustavo Dias2', email: 'gustavf@gmail.com'),
      ContactModel(name: 'Gustavo Dias Pessoal', email: 'gustavf@gmail.noia'),
    ];
    registerFallbackValue(contacts.first);
  });

  blocTest<ContactUpdateCubit, ContactUpdateCubitState>(
    'Deve atualizar um contato', 
    build: () => cubit,
    act: (cubit) => cubit.save(
      name: 'name', 
      email: 'email'
    ),
    setUp: () {
      when(() => repository.update(any()),).thenAnswer((_) async => {});
      when(() => repository.findAll()).thenAnswer((_) async => contacts);
    },
    expect: () => [
      ContactUpdateCubitState.loading(),
      ContactUpdateCubitState.success(),
      ContactUpdateCubitState.loading(),
      ContactUpdateCubitState.data(contacts: contacts),
      // ContactUpdateCubitState.error(error: 'Erro ao buscar contatos')
    ],
  );

    blocTest<ContactUpdateCubit, ContactUpdateCubitState>(
    'Deve retornar erro ao atualizar um contato', 
    build: () => cubit,
    act: (cubit) => cubit.save(
      name: 'name', 
      email: 'email'
    ),
    setUp: () {
      when(() => repository.update(any()),).thenThrow(Exception());
    },
    expect: () => [
      ContactUpdateCubitState.loading(),
      ContactUpdateCubitState.error(error: 'Erro ao atualizar contato'),
    ],
  );

}