import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  
  //declaração
  late ContactsRepository repository;
  late ContactListBloc bloc;
  late List<ContactModel> contacts;

  //preparação
  setUp((){
    repository = MockContactsRepository();
    bloc = ContactListBloc(repository: repository);
    contacts = [
      ContactModel(name: 'Gustavo Dias2', email: 'gustavf@gmail.com'),
      ContactModel(name: 'Gustavo Dias Pessoal', email: 'gustavf@gmail.noia'),
    ];
    registerFallbackValue(contacts.first);
  });

  //execução
  blocTest<ContactListBloc, ContactListState>(
    'Deve buscar os contatos', 
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    setUp: () {
      when(() => repository.findAll(),).thenAnswer((_) async => contacts);
    },
    expect: () => [
      ContactListState.loading(),
      ContactListState.data(contacts: contacts),
    ]
  );


  blocTest<ContactListBloc, ContactListState>(
    'Deve retornar erro ao buscar os contatos', 
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    // setUp: () {
    //   when(() => repository.findAll(),).thenAnswer((_) async => contacts);
    // },
    expect: () => [
      ContactListState.loading(),
      ContactListState.error(error: 'Erro ao buscar contatos!'),
    ]
  );

  blocTest<ContactListBloc, ContactListState>(
    'Deve deletar o contato', 
    build: () => bloc,
    act: (bloc) => bloc.add(ContactListEvent.delete(
      model: ContactModel(
          name: 'name', 
          email: 'email'
        ),
      ),
    ),
    setUp: () {
      when(() => repository.delete(any()),).thenAnswer((invocation) async {return true;});
    },
    expect: () => [
      ContactListState.loading(),
    ]
  );

  blocTest<ContactListBloc, ContactListState>(
    'Deve retornar erro ao deletar o contato', 
    build: () => bloc,
    act: (bloc) => bloc.add(ContactListEvent.delete(
      model: ContactModel(
          name: 'name', 
          email: 'email'
        ),
      ),
    ),
    setUp: () {
      when(() => repository.delete(any()),).thenThrow(Exception());
    },
    expect: () => [
      ContactListState.loading(),
      ContactListState.error(error: 'Erro ao deletar contato')
    ]
  );
}