import 'package:flutter/material.dart';

EdgeInsets tabScrollPadding(BuildContext context) {
  final mq = MediaQuery.of(context);
  final bottomSafe = mq.viewPadding.bottom;
  const extra = 40.0;

  return EdgeInsets.fromLTRB(16, 0, 16, bottomSafe + extra);
}