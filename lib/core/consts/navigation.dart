import 'package:flutter/material.dart';

navigateTo(context, Widget routeName) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => routeName,
    ),
  );
}

navigateWithReplacment(context, Widget routeName) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => routeName,
    ),
  );
}

navigateAndRemoveUntil(context, Widget routeName) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => routeName,
    ),
    (r) => false,
  );
}
