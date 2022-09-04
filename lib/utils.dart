String? validateEmpty(value) {
  if (value == null || value.isEmpty) {
    return "Field is required";
  }
  return null;
}

String? validateEmail(value) {
  String? checkEmpty = validateEmpty(value);
  if (checkEmpty != null) {
    return checkEmpty;
  }
  if (!RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
    return "Please enter a valid email address";
  }
  return null;
}
