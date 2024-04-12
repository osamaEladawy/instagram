/*this functionn used to validate Forma*/

//to use validation for entered for user

validateInput(String value, int min, int max) {
  if (value.isEmpty) {
    return "this field must not be empty";
  }
  if (value.length < min) {
    return "this field must not be less than $min";
  }
  if (value.length > max) {
    return "this field must not be greater than $max";
  }
}
