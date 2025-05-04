
import 'dart:convert';

import 'package:contact_bloc/models/contact_model.dart';
import 'package:dio/dio.dart';

class ContactsRepository {

  Future<List<ContactModel>> findAll() async {
    final response = await Dio().get('http://localhost:8080/contacts');
    return response.data?.map<ContactModel>((contact) => ContactModel.fromMap(contact)).toList();
  }

  Future<void> create(ContactModel model) async => 
      Dio().post('http://localhost:8080/contacts', data: json.encode(model.toMap()));

  Future<void> update(ContactModel model) async => 
      Dio().put('http://localhost:8080/contacts/${model.id}', data: model.toMap());

  Future<bool> delete(ContactModel model) async => 
      Dio().delete('http://localhost:8080/contacts/${model.id}').then((_) {
        return true;
      }).catchError((_) {
        return false;
      });
      
}