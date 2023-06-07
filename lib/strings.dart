class Strings {
  static String appName = "Logger";

  // Display text
  static String empty = "The list is empty.\nAdd new items using the button.";
  static String areSure =
      "Are you sure you want to delete this list? All items inside will be permanently deleted.";
  static String confirmation = "Confirmation";
  static String listName = "New list name";
  static String addNewDate = "Add new date";
  static String addNewList = "Add new list";
  static String changeName = "Name change";
  static String changeSorting = "List sorting";

  // List options
  static String addFav = "Add favorite";
  static String remFav = "Remove favorite";
  static String quickAdd = "Insert current time";
  static String removeForever = "Delete forever";

  // Hints / Labels
  static String newListHint = "Workout";

  // Sorting
  static String sortName = "Alphabetically";
  static String sortDateAsc = "Date (newest)";
  static String sortDateDesc = "Date (oldest)";
  static String sortCounterAsc = "Counter (highest)";
  static String sortCounterDesc = "Counter (lowest)";

  // Buttons
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
