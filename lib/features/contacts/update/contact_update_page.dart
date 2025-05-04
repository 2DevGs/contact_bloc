import 'package:contact_bloc/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUpdatePage extends StatefulWidget {
  final ContactModel contact;

  const ContactUpdatePage({super.key, required this.contact});

  @override
  State<ContactUpdatePage> createState() => _ContactUpdatePageState();
}

class _ContactUpdatePageState extends State<ContactUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEC;
  late final TextEditingController _emailEC;

  @override
  void initState() {
    super.initState();
    _nameEC = TextEditingController(text: widget.contact.name);
    _emailEC = TextEditingController(text: widget.contact.email);
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Update'),
      ),
      body: BlocListener<ContactUpdateBloc, ContactUpdateState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () => Navigator.of(context).pop(),
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameEC,
                    decoration: const InputDecoration(
                      label: Text('Nome'),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório!!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailEC,
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'E-mail é obrigatório!!';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final validate =
                          _formKey.currentState?.validate() ?? false;
                      if (validate) {
                        context.read<ContactUpdateBloc>().add(
                              ContactUpdateEvent.save(
                                id: widget.contact.id!,
                                name: _nameEC.text,
                                email: _emailEC.text,
                              ),
                            );
                      }
                    },
                    child: Text('Salvar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final validate =
                          _formKey.currentState?.validate() ?? false;
                      if (validate) {
                        context.read<ContactUpdateBloc>().add(
                              ContactUpdateEvent.delete(
                                id: widget.contact.id!,
                                name: _nameEC.text,
                                email: _emailEC.text,
                              ),
                            );
                      }
                    },
                    child: Text('Apagar'),
                  ),
                  Loader<ContactUpdateBloc, ContactUpdateState>(
                    selector: (state) {
                      return state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
