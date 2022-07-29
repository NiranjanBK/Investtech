import 'dart:ui';

class ColorHex {
  static const int PRIMARY_COLOR = 0xFFFFFFFF;
  static const int PRIMARY_COLOR_DARK = 0xFFCCCCCC;
  static const int ACCENT_COLOR = 0xFFFF6600;

  static const int GREY = 0xFF808080;
  static const int DARK_GREY = 0xFF555557;

  static const int colorPrimaryDark = 0xFFccc;
  static const int colorAccent = 0xFFFF6600;
  static const int darkColorPrimary = 0xFF3d3d3d;
  static const int darkColorPrimaryDark = 0xFF3d3d3d;
  static const int colorAccentLight = 0xFF1F60;
  static const int ic_launcher_background = 0xFFFFFFFF;
  static const int windowBackground = 0xFFFFFFFF;
  static const int navigationBarColor = 0xFF000000;
  static const int fuchsia = 0xFFFF00FF;
  static const int silver = 0xFFC0C0C0;
  static const int gray = 0xFF808080;
  static const int olive = 0xFF808000;
  static const int purple = 0xFF800080;
  static const int maroon = 0xFF800000;
  static const int aqua = 0xFF00FFFF;
  static const int lime = 0xFF00FF00;
  static const int teal = 0xFF008080;
  static const int blue = 0xFF0000FF;
  static const int navy = 0xFF000080;
  static const int shadow = 0xFF555555;
  static const int title = 0xFF777777;
  static const int orange = 0xFFFF6600;
  static const int lightGrey = 0xFFE8E8E8;
  static const int warmGrey = 0xFF9b9b9b;
  static const int mediumGrey = 0xFFC0C0C0;
  static const int metalGrey = 0xFF4A5357;
  static const int green = 0xFF19a019;
  static const int red = 0xFFb70b0b;
  static const int yellow = 0xFFe6e600;
  static const int lightGreen = 0xFFf5f8f2;
  static const int lightRed = 0xFFfaf2f3;
  static const int lightYellow = 0xFFfefdf2;
  static const int black = 0xFF000000;
  static const int lightBlack = 0xFF282828;
  static const int white = 0xFFFFFFFF;
  static const int paleWhite = 0xFFf5f3f3;
  static const int orange_light = 0xFFFF8D3C;
  static const int darkGrey = 0xFF555557;
  static const int tut_color = 0xFF3F88F7;
  static const int tut_status = 0xFF803400;
  static const int tut_bg = 0xFF40000000;
  static const int body_grey = 0xFF6e6e6e;
  static const int fav_delete = 0xFFF44336;
  static const int subscription_header = 0xFFf1961d;
  static const int subscription_grey = 0xFFe0e0e0;
  static const int subscription_orange = 0xFFf4de9a;
  static const int black_chart_bg = 0xFF282828;
  static const int home_promo_bg = 0xFFeef0ee;
  static const int on_boarding_1 = 0xFF80cbc4;
  static const int on_boarding_2 = 0xFF42bcb0;
  static const int on_boarding_3 = 0xFF5c9ec7;

  static const int APP_GREEN = 0xFF006400;
  static const int APP_YELLOW = 0xFFe6e600;
  static const int APP_RED = 0xFF8b0000;
  static const int APP_BLACK = 0xFF000000;
  static const int APP_WHITE = 0xFFffffff;

  static const int APP_BRIGHT_GREEN = 0xFF24A73B;
  static const int APP_BRIGHT_YELLOW = 0xFFE1E60B;
  static const int APP_BRIGHT_RED = 0xFFBE0005;

  static const int APP_GREEN_LIGHT = 0xFF008000;
  static const int APP_RED_LIGHT = 0xFFcc1700;

// for PieChart
  static const int APP_GREEN_A90 = 0xFFE687E752;
  static const int APP_YELLOW_A90 = 0xFFE6FFFB46;
  static const int APP_RED_A90 = 0xFFE6E53D00;

  Color getBoarderColor(int evalCode) {
    if (evalCode == 1) {
      return const Color(ColorHex.APP_GREEN_LIGHT);
    } else if (evalCode == 2) {
      return const Color(ColorHex.APP_GREEN);
    } else if (evalCode == -1) {
      return const Color(ColorHex.APP_RED_LIGHT);
    } else if (evalCode == -2) {
      return const Color(ColorHex.APP_RED);
    } else {
      return const Color(ColorHex.APP_YELLOW);
    }
  }
}
