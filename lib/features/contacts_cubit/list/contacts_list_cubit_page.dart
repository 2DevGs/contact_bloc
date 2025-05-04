import 'package:contact_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsListCubitPage extends StatelessWidget {

  const ContactsListCubitPage({ super.key });

   @override
   Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('List Cubit'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              await Navigator.pushNamed(context, '/contacts/cubit/register');
              context.read<ContactListCubit>().findAll();
            },
            child: const Icon(Icons.add),
          ),
           body: RefreshIndicator(
            onRefresh: () => context.read<ContactListCubit>().findAll(),
             child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    children: [
                      Loader<ContactListCubit, ContactListCubitState>(
                        selector: (state) {
                          return state.maybeWhen(
                            loading: () => true,
                            orElse: () => false,
                          );
                        },
                      ),
                      BlocSelector<ContactListCubit, ContactListCubitState, List<ContactModel>>(
                        selector: (state) {
                          return state.maybeWhen(
                            data: (contacts) => contacts,
                            orElse: () => <ContactModel>[]
                          );
                        }, 
                        builder: (_, contacts) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: contacts.length,
                            itemBuilder: (_, index) {
                              final contact = contacts[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/contacts/cubit/update', 
                                      arguments: contact);
                                    context.read<ContactListCubit>().findAll();
                                },
                                onLongPress: () => context.read<ContactListCubit>().deleteByModel(contact),
                                title: Text(contact.name),
                                subtitle: Text(contact.email),
                              );
                            }
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
             ),
           ),
       );
  }
}