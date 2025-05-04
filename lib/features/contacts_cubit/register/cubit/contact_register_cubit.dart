

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_register_cubit.freezed.dart';
part 'contact_register_cubit_state.dart';

class ContactRegisterCubit extends Cubit<ContactRegisterCubitState> {

  final ContactsRepository _contactsRepository;
  
  ContactRegisterCubit({required ContactsRepository contactsRepository}) 
      : _contactsRepository = contactsRepository,
      super(ContactRegisterCubitState.initial());

  Future<void> findAll() async {
    try {
      emit(ContactRegisterCubitState.loading());
      final contacts = await _contactsRepository.findAll();
      await Future.delayed(const Duration(seconds: 2));
      emit(ContactRegisterCubitState.data(contacts: contacts));
    } catch (e, s) {
      log('Erro ao buscar contatos', error: e, stackTrace: s);
      emit(ContactRegisterCubitState.error(error: 'Erro ao buscar contatos'));
    }
  }

    Future<void> createModel({
    int? id,
    required String name,
    required String email}) async {
      try {
        emit(ContactRegisterCubitState.loading());
        final model = ContactModel(
          id: id,
          name: name, 
          email: email,
        );
        await _contactsRepository.create(model);
        emit(ContactRegisterCubitState.success());
        await findAll();
      } catch (e, s) {
        log('Erro ao registrar contato', error: e, stackTrace: s);
        emit(ContactRegisterCubitState.error(error: 'Erro ao registrar contato'));
      }
  }

}