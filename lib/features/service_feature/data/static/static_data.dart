import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/service_feature/data/model/service_item.dart';
import 'package:flutter/material.dart';

const services = [
  ServiceItem(
    icon: Icons.edit,
    title: 'Course Registration',
    subtitle: 'Add and drop courses',
    bgColor: Color(0xFFEEF2FF),
    borderColor: Color(0xFFC7D2FE),
    accentColor: AppColors.primary,
  ),
  ServiceItem(
    icon: Icons.receipt,
    title: 'Request Transcript',
    subtitle: 'Official academic transcript',
    bgColor: Color(0xFFEDE9FE),
    borderColor: Color(0xFFDDD6FE),
    accentColor: AppColors.purple,
  ),
  ServiceItem(
    icon: Icons.warning,
    title: 'Academic Warning',
    subtitle: 'Your current academic status',
    bgColor: Color(0xFFCCFBF1),
    borderColor: Color(0xFF99F6E4),
    accentColor: Colors.black,
  ),
];
