import 'package:equatable/equatable.dart';

class CustomExceptionHandler with EquatableMixin {
  final String message;
  CustomExceptionHandler({
    required this.message,
  });

  CustomExceptionHandler copyWith({
    String? message,
  }) {
    return CustomExceptionHandler(
      message: message ?? this.message,
    );
  }

  @override
  String toString() => 'CustomExceptionHandler(message: $message)';

  @override
  List<Object> get props => [message];
}
