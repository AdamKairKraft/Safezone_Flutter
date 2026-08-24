import 'package:flutter/material.dart';

import '../models/compliance_status.dart';
import '../models/report.dart';
import '../models/she_file.dart';
import '../theme/app_theme.dart';

enum PillVariant { green, amber, red, blue, grey }

class PillStyle {
  const PillStyle(this.background, this.foreground);
  final Color background;
  final Color foreground;
}

const _pillStyles = {
  PillVariant.green: PillStyle(AppColors.greenBg, AppColors.green),
  PillVariant.amber: PillStyle(AppColors.amberBg, AppColors.amber),
  PillVariant.red: PillStyle(AppColors.redBg, AppColors.red),
  PillVariant.blue: PillStyle(Color(0xFFDBEAFE), AppColors.blueDark),
  PillVariant.grey: PillStyle(AppColors.greyBg2, AppColors.sub),
};

PillStyle pillStyle(PillVariant variant) => _pillStyles[variant]!;

const complianceStateVariant = {
  ComplianceState.ok: PillVariant.green,
  ComplianceState.dueSoon: PillVariant.amber,
  ComplianceState.overdue: PillVariant.red,
};

const complianceStateLabel = {
  ComplianceState.ok: 'Up-to-date',
  ComplianceState.dueSoon: 'Due soon',
  ComplianceState.overdue: 'Overdue',
};

const reportStatusVariant = {
  ReportStatus.draft: PillVariant.grey,
  ReportStatus.submitted: PillVariant.green,
  ReportStatus.underReview: PillVariant.blue,
  ReportStatus.closed: PillVariant.grey,
};

const sheFileStatusVariant = {
  SheFileStatus.valid: PillVariant.green,
  SheFileStatus.expiringSoon: PillVariant.amber,
  SheFileStatus.expired: PillVariant.red,
};
