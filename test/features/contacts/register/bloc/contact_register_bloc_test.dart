import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts/register/bloc/contact_register_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {

  late ContactsRepository repository;
  late ContactRegisterBloc bloc;
  late List<ContactModel> contacts;

  //preparação
  setUp((){
    repository = MockContactsRepository();
    bloc = ContactRegisterBloc(contactsRepository: repository);
    contacts = [
      ContactModel(name: 'Gustavo Dias2', email: 'gustavf@gmail.com'),
      ContactModel(name: 'Gustavo Dias Pessoal', email: 'gustavf@gmail.noia'),
    ];
    registerFallbackValue(contacts.first);
  });

  blocTest<ContactRegisterBloc, ContactRegisterState>(
    'Deve registrar o contato', 
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactRegisterEvent.save(
      name: 'name',
      email: 'email',
    )),
    setUp: () {
      // final model = ContactModel(name: 'name1', email: 'email1');
      when(() => repository.create(any()),).thenAnswer((_) async => {});
    },
    expect: () => [
      ContactRegisterState.loading(),
      ContactRegisterState.success()
    ]
  );

  blocTest<ContactRegisterBloc, ContactRegisterState>(
    'Erro ao salvar um novo contato', 
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactRegisterEvent.save(
      name: '',
      email: '',
    )),
    setUp: () {

      when(() => repository.create(any()),).thenThrow(Exception());
    },
    expect: () => [
      ContactRegisterState.loading(),
      // ContactRegisterState.error(message: ''),
      ContactRegisterState.error(message: 'Erro ao salvar um novo contato')
    ]
  );

}