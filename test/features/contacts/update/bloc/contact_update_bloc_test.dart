import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {

  //declaração
  late ContactsRepository repository;
  late ContactUpdateBloc bloc;
  late List<ContactModel> contacts;

  //preparação
  setUp((){
    repository = MockContactsRepository();
    bloc = ContactUpdateBloc(contactsRepository: repository);
    contacts = [
      ContactModel(id: 0,name: 'Gustavo Dias2', email: 'gustavf@gmail.com'),
      ContactModel(id: 0,name: 'Gustavo Dias Pessoal', email: 'gustavf@gmail.noia'),
    ];
    registerFallbackValue(contacts.first);
  });

  //execução
  blocTest<ContactUpdateBloc, ContactUpdateState>(
    'Deve atualizar o contato',
    build: () => bloc,
    act: (bloc) => bloc.add(ContactUpdateEvent.save(
      id: 0,
      name: 'name',
      email: 'email',
    ),),
    setUp: () {
      when(() => repository.update(any()),).thenAnswer((invocation) async {},);
    },
    expect: () => [
      ContactUpdateState.loading(),
      ContactUpdateState.success(),
    ],
  );


  blocTest<ContactUpdateBloc, ContactUpdateState>(
    'Deve retornar erro ao atualizar o contato', 
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactUpdateEvent.save(
      id: 0,
      name: '',
      email: '',
    )),
    setUp: () {
      when(() => repository.update(any()),).thenThrow(Exception());
    },
    expect: () => [
      ContactUpdateState.loading(),
      ContactUpdateState.error(message: 'Erro ao atualizar o contato'),
    ]
  );
}