
class SignupWithEmailAndPasswordFailure{
  final String message;

  const SignupWithEmailAndPasswordFailure([this.message = "An Unknown error occured."]);

  factory SignupWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak-password':
        return const SignupWithEmailAndPasswordFailure('Please enter a stronger password.');
      case 'invalid-email':
        return const SignupWithEmailAndPasswordFailure('Email is not valid or badly formatted.');
      case 'email-already-in-use':
        return const SignupWithEmailAndPasswordFailure('An account already exists for that email.');
      case 'operation-not-allowed':
        return const SignupWithEmailAndPasswordFailure('Not allowed. Please contact Support at support@givision.com');
      case 'user-disabled':
        return const SignupWithEmailAndPasswordFailure('User has been disabled. Please contact Support at support@givision.com');
      default:
        return const SignupWithEmailAndPasswordFailure();
    }
  }
}