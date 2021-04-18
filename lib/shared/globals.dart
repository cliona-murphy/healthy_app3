library healthy_app.globals;

bool newDateSelected = false;
String selectedDate = getCurrentDate();
int kcalIntakeTarget = 2000;
int kcalOutputTarget = 2000;
int waterIntakeTarget = 0;
DateTime newDate = new DateTime.now();

String getCurrentDate(){
  var date = new DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
  return formattedDate;
}