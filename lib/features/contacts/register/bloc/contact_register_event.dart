part of 'contact_register_bloc.dart';

  @freezed
  class ContactRegisterEvent with _$ContactRegisterEvent {
    const factory ContactRegisterEvent.save({
      required String name,
      required String email,
    }) = _Save;
  }