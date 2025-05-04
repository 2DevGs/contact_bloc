// import 'package:contact_bloc/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:contact_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contact_bloc/features/contacts_cubit/update/cubit/contact_update_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUpdateCubitPage extends StatefulWidget {
  final ContactModel contact;

  const ContactUpdateCubitPage({super.key, required this.contact});

  @override
  State<ContactUpdateCubitPage> createState() => _ContactUpdateCubitPageState();
}

class _ContactUpdateCubitPageState extends State<ContactUpdateCubitPage> {
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
        title: const Text('Contact Cubit Update'),
      ),
      body: BlocListener<ContactUpdateCubit, ContactUpdateCubitState>(
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
                      // final contact = contacts[index];
                      final validate =
                          _formKey.currentState?.validate() ?? false;
                      if (validate) {
                        context.read<ContactUpdateCubit>().save(
                          id: widget.contact.id!,
                          name: _nameEC.text,
                          email: _emailEC.text,
                        //       ContactUpdateEvent.save(
                        //         id: widget.contact.id!,
                        //         name: _nameEC.text,
                        //         email: _emailEC.text,
                        //       ),
                            );
                      }
                    },
                    child: Text('Salvar'),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     final validate =
                  //         _formKey.currentState?.validate() ?? false;
                  //     if (validate) {
                  //       context.read<ContactUpdateCubit>().add(
                  //             ContactUpdateCubit.save(
                  //               id: widget.contact.id!,
                  //               name: _nameEC.text,
                  //               email: _emailEC.text,
                  //             ),
                  //           );
                  //     }
                  //   },
                  //   child: Text('Apagar'),
                  // ),
                  Loader<ContactUpdateCubit, ContactUpdateCubitState>(
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
