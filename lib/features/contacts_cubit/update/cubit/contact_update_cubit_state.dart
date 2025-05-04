part of 'contact_update_cubit.dart';

@freezed
class ContactUpdateCubitState with _$ContactUpdateCubitState {
  factory ContactUpdateCubitState.initial() = _Initial;
  factory ContactUpdateCubitState.loading() = _Loading;
  factory ContactUpdateCubitState.success() = _Success;
  factory ContactUpdateCubitState.data({required List<ContactModel> contacts}) = _Data;
  factory ContactUpdateCubitState.error({required String error}) = _Error;
}