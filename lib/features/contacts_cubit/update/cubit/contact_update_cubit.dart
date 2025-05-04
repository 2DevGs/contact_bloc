
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:contact_bloc/repositories/contacts_repository.dart';

part 'contact_update_cubit.freezed.dart';
part 'contact_update_cubit_state.dart';

class ContactUpdateCubit extends Cubit<ContactUpdateCubitState> {

  final ContactsRepository _contactsRepository;
  
  ContactUpdateCubit({
    required ContactsRepository contactsRepository,
  }) : _contactsRepository = contactsRepository,
        super(ContactUpdateCubitState.initial());

  Future<void> findAll() async {
    try {
      emit(ContactUpdateCubitState.loading());
      final contacts = await _contactsRepository.findAll();
      await Future.delayed(const Duration(seconds: 2));
      emit(ContactUpdateCubitState.data(contacts: contacts));
    } catch (e, s) {
      log('Erro ao buscar contatos', error: e, stackTrace: s);
      emit(ContactUpdateCubitState.error(error: 'Erro ao buscar contatos'));
    }
  }

  Future<void> save({int? id,required String name, required String email}) async {
    try {
      emit(ContactUpdateCubitState.loading());
      final model = ContactModel(
        id: id,
        name: name,
        email: email,
      );
      await _contactsRepository.update(model);
      emit(ContactUpdateCubitState.success());
      await findAll();
    } catch (e, s) {
      log('Erro ao atualizar contato', error: e, stackTrace: s);
      emit(ContactUpdateCubitState.error(error: 'Erro ao atualizar contato'));
    }
  }

}
