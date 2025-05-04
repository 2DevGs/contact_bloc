import 'package:contact_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsListPage extends StatelessWidget {

  const ContactsListPage({ super.key });

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Contact List'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              await Navigator.pushNamed(context, '/contacts/register');
              context.read<ContactListBloc>().add(const ContactListEvent.findAll());
            },
            child: const Icon(Icons.add),
          ),
          body: BlocListener<ContactListBloc, ContactListState>(
            listenWhen: (previous, current) {
              return current.maybeWhen(
                error: (error) => true,
                orElse: () => false,
              );
            },
            listener: (context, state) {
              state.whenOrNull(
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    )
                  );
                },
              );
            },
            child: RefreshIndicator(
              onRefresh: () async => context.read<ContactListBloc>().add(ContactListEvent.findAll()),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      children: [
                        Loader<ContactListBloc, ContactListState>(
                          selector: (state) {
                            return state.maybeWhen(
                              loading: () => true,
                              orElse: () => false,
                            );
                          },
                        ),
                        BlocSelector<ContactListBloc, ContactListState, List<ContactModel>>(
                          selector: (state) {
                            return  state.maybeWhen(
                              data: (contacts) => contacts,
                              orElse: () => [],
                            );
                          }, 
                          builder: (_, contacts) {
                              print(contacts);
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: contacts.length,
                              itemBuilder: (context, index) {
                                final contact = contacts[index];
                                return ListTile(
                                  onLongPress: () {
                                    context.read<ContactListBloc>().add(ContactListEvent.delete(model: contact));
                                  },
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context, '/contacts/update', 
                                      arguments: contact);
                                    context.read<ContactListBloc>().add(const ContactListEvent.findAll());
                                  },
                                  title: Text(
                                    contact.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    ),
                                  subtitle: Text(contact.email),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
      );
  }
}