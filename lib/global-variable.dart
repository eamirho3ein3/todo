class GlobVariable {
  static GlobVariable _instance;
  factory GlobVariable() => _instance ??= new GlobVariable._();
  GlobVariable._();

  double statusBarHeight;

  double getStatusBarHeight() {
    return statusBarHeight;
  }

  setStatusBarHeight(double height) {
    statusBarHeight = height;
  }
}
