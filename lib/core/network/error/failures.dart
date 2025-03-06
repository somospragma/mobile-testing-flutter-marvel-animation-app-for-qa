abstract class Failure {

  const Failure(this.errorMessage);
  final String errorMessage;

  List<Object> get props => <String>[errorMessage];
}

/// General failures
class ServerFailure extends Failure {

  const ServerFailure(super.errorMessage, this.statusCode);
  final int? statusCode;
}
