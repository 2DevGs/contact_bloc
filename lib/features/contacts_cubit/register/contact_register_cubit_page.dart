import 'package:contact_bloc/features/contacts_cubit/register/cubit/contact_register_cubit.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactRegisterCubitPage extends StatefulWidget {

  const ContactRegisterCubitPage({ super.key });

  @override
  State<ContactRegisterCubitPage> createState() => _ContactRegisterCubitPageState();
}

class _ContactRegisterCubitPageState extends State<ContactRegisterCubitPage> {

  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Register Cubit'),),
           body: BlocListener<ContactRegisterCubit, ContactRegisterCubitState>(
            listenWhen: (previous, current) {
              return current.maybeWhen(
                success: () => true,
                error: (message) => true,
                orElse: () => false,
              );
            },
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
                }
              );
            },
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Form (
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameEC,
                      decoration: const InputDecoration(
                        label: Text('Nome'),
                      ),
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
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
                        if(value == null || value.isEmpty) {
                          return 'E-mail é obrigatório!!';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final validate = _formKey.currentState?.validate() ?? false;
                        if (validate) {
                          context.read<ContactRegisterCubit>().createModel(
                              name: _nameEC.text, 
                              email: _emailEC.text, 
                          );
                        }
                      }, 
                      child: Text('Salvar'),
                    ),
                    Loader<ContactRegisterCubit, ContactRegisterCubitState>(
                      selector: (state) {
                        return state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                      },
                    ),
                  ],
                )
              ),
             ),
           ),
       );
  }
}