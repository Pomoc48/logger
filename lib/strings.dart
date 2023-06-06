class Strings {
  static String appName = "Logger";

  // Display text
  static String empty = "No items to display";
  static String areSure =
      "Are you sure you want to delete this list?\nAll items inside will be permanently deleted.";
  static String confirmation = "Confirmation";
  static String addNewCounter = "Add new counter";
  static String addNewDate = "Add new date";
  static String changeSorting = "List sorting";

  // List options
  static String addFav = "Add favorite";
  static String remFav = "Remove favorite";
  static String quickAdd = "Insert current time";
  static String changeName = "Name change";
  static String removeForever = "Delete forever";

  // Hints / Labels
  static String newListHint = "Workout";
  static String counterName = "Name of the counter";

  // Sorting
  static String sortName = "Alphabetically";
  static String sortDateAsc = "Date (newest)";
  static String sortDateDesc = "Date (oldest)";
  static String sortCounterAsc = "Counter (highest)";
  static String sortCounterDesc = "Counter (lowest)";

  // Buttons
  static String newItem = "New";
  static String create = "Create";
  static String cancel = "Cancel";
  static String delete = "Delete";
  static String rename = "Rename";

  // Feedback
  static String listAdded = "New list added";
  static String listRemoved = "List removed";
  static String itemAdded = "New item added";
  static String itemRemoved = "Item removed";
  static String listFavToggle = "Favorite status changed";
  static String listRenamed = "List renamed";
}

class Routes {
  static String home = "/home";
  static String list = "/list";
}

class DataKeys {
  static String sorting = "sortType";
  static String data = "listData";
}
