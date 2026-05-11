import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/pk_design.dart';

class VitalChartSeries {
  const VitalChartSeries({
    required this.label,
    required this.values,
    required this.color,
    this.unit = '',
  });

  final String label;
  final List<double> values;
  final Color color;
  final String unit;
}

class VitalsTrendChart extends StatelessWidget {
  const VitalsTrendChart({
    required this.title,
    required this.subtitle,
    required this.series,
    required this.xLabels,
    this.height = 260,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<VitalChartSeries> series;
  final List<String> xLabels;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      soft: true,
      padding: const EdgeInsets.all(PkSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.35,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
              const PkBadge(label: '7 hari', tone: PkTone.brand, icon: Icons.show_chart_rounded),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          SizedBox(
            height: height,
            width: double.infinity,
            child: CustomPaint(
              painter: _VitalsTrendChartPainter(
                series: series,
                xLabels: xLabels,
                textColor: PkColors.muted,
                gridColor: PkColors.line,
              ),
            ),
          ),
          const SizedBox(height: PkSpacing.md),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: series.map((item) => _LegendItem(series: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.series});

  final VitalChartSeries series;

  @override
  Widget build(BuildContext context) {
    final latest = series.values.isEmpty ? 0 : series.values.last;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: series.color.withValues(alpha: 0.10),
        borderRadius: PkRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: series.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            '${series.label}: ${latest.toStringAsFixed(0)}${series.unit}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _VitalsTrendChartPainter extends CustomPainter {
  const _VitalsTrendChartPainter({
    required this.series,
    required this.xLabels,
    required this.textColor,
    required this.gridColor,
  });

  final List<VitalChartSeries> series;
  final List<String> xLabels;
  final Color textColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final values = series.expand((item) => item.values).toList();
    if (values.length < 2) return;

    final chartRect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 36);
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final padding = math.max((maxValue - minValue) * 0.16, 8);
    final minY = minValue - padding;
    final maxY = maxValue + padding;
    final range = math.max(maxY - minY, 1);

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(Offset(chartRect.left, y), Offset(chartRect.right, y), gridPaint);
    }

    final labelStyle = TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w700);
    for (var i = 0; i < xLabels.length; i++) {
      final x = chartRect.left + chartRect.width * i / math.max(xLabels.length - 1, 1);
      final painter = TextPainter(
        text: TextSpan(text: xLabels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x - painter.width / 2, chartRect.bottom + 12));
    }

    for (final chartSeries in series) {
      if (chartSeries.values.length < 2) continue;

      final points = <Offset>[];
      for (var i = 0; i < chartSeries.values.length; i++) {
        final x = chartRect.left + chartRect.width * i / (chartSeries.values.length - 1);
        final normalized = (chartSeries.values[i] - minY) / range;
        final y = chartRect.bottom - normalized * chartRect.height;
        points.add(Offset(x, y));
      }

      final fillPath = Path()..moveTo(points.first.dx, chartRect.bottom);
      for (final point in points) {
        fillPath.lineTo(point.dx, point.dy);
      }
      fillPath.lineTo(points.last.dx, chartRect.bottom);
      fillPath.close();

      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              chartSeries.color.withValues(alpha: 0.14),
              chartSeries.color.withValues(alpha: 0.00),
            ],
          ).createShader(chartRect),
      );

      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        final previous = points[i - 1];
        final current = points[i];
        final controlX = (previous.dx + current.dx) / 2;
        path.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = chartSeries.color
          ..strokeWidth = 3.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      for (final point in points) {
        canvas.drawCircle(point, 4, Paint()..color = Colors.white);
        canvas.drawCircle(point, 3, Paint()..color = chartSeries.color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VitalsTrendChartPainter oldDelegate) {
    return oldDelegate.series != series || oldDelegate.xLabels != xLabels;
  }
}
