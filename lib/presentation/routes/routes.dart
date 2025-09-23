class Routes {
  //#region No access
  static const unauthorized = "unauthorized";
  static const pageNotFound = "page-not-found";

  //#endregion No access

  static const home = "home";

  //#region Login - Register
  static const signIn = "signIn";
  static const forgotPassword = "forgot-password";
  static const register = "register";
  static const createPassword = "create-password";
  static const createLibrary = "create-library";
  static const createBook = "create-book";
  static const editBook = "edit-book/:bookId";

  //#endregion Login - Register

  //#region Home
  static const dashboard = "dashboard";
  static const books = "books";

  //#endregion Home
}
