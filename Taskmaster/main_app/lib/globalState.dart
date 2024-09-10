class GlobalState{

  static final GlobalState _instance =  GlobalState._internal();

  DateTime _selectedDate = DateTime.now();

  factory GlobalState(){
    return _instance;
  }

  GlobalState._internal();

  DateTime get selectedDate=>_selectedDate;

  set selectedDate(DateTime date){
    _selectedDate = date;
  }
}