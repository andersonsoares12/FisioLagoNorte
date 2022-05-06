import 'package:flutter/material.dart';

import 'langOther.dart';

class LangData{
  LangData({required this.name, required this.engName, required this.image,
    required this.current, required this.id, required this.direction, required this.locale});
  String name;
  String engName;
  String image;
  bool current;
  int id;
  TextDirection direction;
  String locale;
}

class Lang {

  static var portugal = 1;
  static var german = 2;
  static var espanol = 3;
  static var french = 4;
  static var arabic = 6;
  static var english = 7;
  static var rus = 8;

  var directionLTR = TextDirection.ltr;
  var direction = TextDirection.ltr;
  Map<int, String>? defaultLang;
  var init = false;
  String locale = "en";

  List<LangData> langData = [

    LangData(name: "Português", engName: "Portuguese", image: "assets/country/portugal.png", current: false,
        id: portugal, direction: TextDirection.ltr, locale: "pt"),
    LangData(name: "Deutsh", engName: "German", image: "assets/country/ger.png", current: false,
        id: german, direction: TextDirection.ltr, locale: "de"),
    LangData(name: "Spana", engName: "Spanish", image: "assets/country/esp.png", current: false,
        id: espanol, direction: TextDirection.ltr, locale: "es"),
    LangData(name: "Français", engName: "French", image: "assets/country/fra.png", current: false,
        id: french, direction: TextDirection.ltr, locale: "fr"),
    LangData(name: "عربى", engName: "Arabic", image: "assets/country/arabic.png", current: false,
        id: arabic, direction: TextDirection.rtl, locale: "ar"),
    LangData(name: "English", engName: "English", image: "assets/country/usa.png", current: false,
        id: english, direction: TextDirection.ltr, locale: "en"),
    LangData(name: "Русский", engName: "Russian", image: "assets/country/rus.jpg", current: false,
        id: rus, direction: TextDirection.ltr, locale: "ru"),
  ];

  //
  //
  //
  setLang(int id){


    if (id == portugal){
      defaultLang = langPort;
      init = true;
    }
    if (id == german) {
      defaultLang = langDeu;
      init = true;
    }
    if (id == espanol) {
      defaultLang = langEsp;
      init = true;
    }
    if (id == french) {
      defaultLang = langFrench;
      init = true;
    }
    if (id == arabic) {
      defaultLang = langArabic;
      init = true;
    }
    if (id == english){
      defaultLang = langEng;
      init = true;
    }
    
    if (id == rus){
      defaultLang = langRus;
      init = true;
    }
    for (var lang in langData) {
      lang.current = false;
      if (lang.id == id) {
        lang.current = true;
        direction = lang.direction;
        locale = lang.locale;
      }
    }
  }

  Map<int, String> langEng = {
    1 : "Clinic",
    2 : "Our Location",
    3 : "Home",
    4 : "Appointment",
    5 : "Messages",
    6 : "Account",
    7 : "Email ID",
    8 : "Password",
    9 : "Forgot password ?",
    10 : "Login",
    11 : "Don't have an account?",
    12 : "Signup",
    13 : "Enter Email ID",
    14 : "Enter Password",
    15 : "Create New Account",
    16 : "Email Verification!",
    17 : "Don't worry, we will find your account",
    18 : "Enter your email id",
    19 : "Please check your email we will send you one OTP on you email.",
    20 : "Send",
    21 : "Reset password email sended. Please check your mail.",
    22 : "Name",
    23 : "Enter your name",
    24 : "Enter your email id",
    25 : "Password",
    26 : "Enter your Password",
    27 : "Confirm Password",
    28 : "Already have an account?",
    29 : "LOGIN",
    30 : "By clicking ",
    31 : " you agree to the following",
    32 : "Privacy Policy",
    33 : "Enter password",
    34 : "Passwords are not equal",
    35 : "Email are wrong",
    36 : "Loading...",
    37 : "Log Out",
    38 : "Change Password",
    39 : "Enter Confirm Password",
    40 : "Password changed",
    41 : "New Password",
    42 : "Enter New Password",
    43 : "Confirm Password",
    44 : "Enter Confirm Password",
    45 : "Personal Info",
    46 : "Edit Your Name",
    47 : "Edit Your Email",
    48 : "Edit Your Contact number",
    49 : "Change Info",
    50 : "Data saved",
    51 : "Our specialists",
    52 : "Today",
    53 : "Search",
    54 : "No messages, yet.",
    55 : "User is disabled. Connect to Administrator for more information.",
    56 : "View all >>",
    57 : "Our Specialist",
    58 : "Services",
    59 : "min",
    60 : "Book Appointment",
    61 : "Appointment",
    62 : "Payment",
    63 : "Finished",
    64 : "Choose Specialist",
    65 : "Weekend",
    66 : "This is weekend",
    67 : "Please select service",
    68 : "Please select specialist",
    69 : "Total Pay",
    70 : "Cash payment",
    71 : "Confirm Payment",
    72 : "Something went wrong. ",
    73 : "Book More Appointment",
    74 : "Go to Appointments",
    75 : "Your Time:",
    76 : "Cancel",
    77 : "Are you sure?",
    78 : "Yes",
    79 : "No",
    80 : "Upcoming",
    81 : "Completed",
    82 : "Canceled",
    83 : "Complete",
    84 : "Rate",
    85 : "Enter your review",
    86 : "You rate ",
    87 : "No appointments",
    88 : "Special offers",
    89 : "from",
    90 : "to",
    91 : "Next",
    92 : "Payed",
    93 : "Not Paid",
    94 : "Minimum",
    95 : "Select Language",
    96 : "About us",
    97 : "Chat",
    98 : "Terms & Conditions",
    99 : "Message ...",
    100 : "Our works",
    101 : "Black mode",
    102 : "This specialist don't make",
    103 : "OTP verification",
    104 : "Phone number",
    105 : "Enter your phone number",
    106 : "Send Code",
    107 : 'Code sent. Please check your phone for the verification code.',
    108 : "Phone number must be ",
    109 : "symbols",
    110 : "Call to Clinic",
    111 : "Open Web Site",
    112 : "Open Instagram page",
    113 : "Share This App",
    114 : "Clinic",
    115 : "gallery",
    116 : "and other",
    117 : "NOW OPEN",
    118 : "NOW CLOSE",
    119 : "All salons",
    120 : "Select Clinica",
    121 : "Work Time for this Salon don't set",
    122 : "This is weekend for this master",
    123 : "No sort",
    124 : "By name A-Z",
    125 : "By name Z-A",
    126 : "Near me",
    127 : "Send Bug Report",
    128 : "Comment",
    129 : "Bug Report",
    130 : "Send Email",
    131 : "Your points",
    132 : "You have",
    133 : "points. Do you want to spend them?",
    134 : "Payment by points",
    135 : "points",
    136 : "Your points",
  };

  String get(int id){
    if (!init) return "";

    var str = defaultLang![id];
    if (str == null) {
      str = langEng[id];
      if (str == null)
        str = "";
    }

    return str;
  }



}

