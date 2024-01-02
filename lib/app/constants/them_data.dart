import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryColor = Color(0xFF1E1E1E);
const Color kSecondaryColor = Color(0xFF2E2E2E);
const Color kAccentColor = Color(0xFF3E3E3E);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kBlackColor = Color(0xFF000000);
const Color kGreyColor = Color(0xFF9E9E9E);
const Color kRedColor = Color(0xFFE53935);
const Color kGreenColor = Color(0xFF43A047);
const Color kBlueColor = Color(0xFF1E88E5);
const Color kYellowColor = Color(0xFFFFEB3B);
const Color kOrangeColor = Color(0xFFFF9800);
const Color kPurpleColor = Color(0xFF9C27B0);
const Color kPinkColor = Color(0xFFE91E63);

const MaterialColor kPrimary = MaterialColor(
  0xFF1E1E1E,
  <int, Color>{
    50: Color(0xFF1E1E1E),
    100: Color(0xFF1E1E1E),
    200: Color(0xFF1E1E1E),
    300: Color(0xFF1E1E1E),
    400: Color(0xFF1E1E1E),
    500: Color(0xFF1E1E1E),
    600: Color(0xFF1E1E1E),
    700: Color(0xFF1E1E1E),
    800: Color(0xFF1E1E1E),
    900: Color(0xFF1E1E1E),
  },
);

ThemeData lightTheme(context) => ThemeData(
      primaryColor: kPrimaryColor,
      primarySwatch: kPrimary,
      scaffoldBackgroundColor: kWhiteColor,
      appBarTheme: AppBarTheme(
        backgroundColor: kWhiteColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          color: kBlackColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: kPrimaryColor,
        selectionColor: kPrimaryColor,
        selectionHandleColor: kPrimaryColor,
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(context).textTheme.copyWith(
              displayLarge: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              displayMedium: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              displaySmall: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              bodyMedium: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              titleMedium: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              titleSmall: GoogleFonts.montserrat(
                color: kBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: kSecondaryColor,
        primary: kPrimaryColor,
        onPrimary: kWhiteColor,
        onSurface: kAccentColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor // button text color
            ),
      ),
    );
