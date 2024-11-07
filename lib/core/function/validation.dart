
validateinput(String value , int min , int max ) {

  if (value.isEmpty) {
    return "can't be Empty";
  }


  if (value.length < min) {
    return "can't be less than $min";
  }


  if (value.length > max) {
    return "can't be large than $max";
  }
}

validatenum(String value , int  number) {

  if (value.isEmpty) {
    return "can't be Empty";
  }


  if (value.length < number) {
    return "can't be less than $number";
  }


  if (value.length > number) {
    return "can't be large than $number";
  }
}

validate(String value ) {

  if (value.isEmpty) {
    return "can't be Empty";
  }

}
