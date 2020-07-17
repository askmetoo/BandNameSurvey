

class LoginFormData
{
  String email ='';
  String password = '';

  Map<String, dynamic> toJSON() => 
  {
    'email': email,
    'password': password
  };

}

class RegisterUserFormData {
  String email = '';
  String password = '';
  String passwordConfirmation = '';

  Map<String, dynamic> toJSON() =>
    {
      'email': email,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
    };
}


class RegisterFormData {
  String name = '';
  int votes = 0;
  String image = '';
  String shortDescription ='';
  String wallPicture = '';


  Map<String, dynamic> toJSON() =>
    {
      'name': name,
      'votes': votes,
      'image': image,
      'shortDescription': shortDescription,
      'wallPicture': wallPicture
    };
}