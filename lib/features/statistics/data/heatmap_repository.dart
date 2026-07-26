import 'dart:math';
import '../domain/heatmap_day.dart';

abstract class HeatmapRepository {
  Future<List<HeatmapDay>> fetchHistory(HeatmapMetric metric, {int days = 182});
}

/// Local implementation generating a plausible-looking history so the
/// heatmap is fully populated and interactive during development. A
/// Supabase-backed repository (reading real logged activity) will
/// replace this behind the same interface once daily logging exists.
class LocalHeatmapRepository implements HeatmapRepository {
  @override
  Future<List<HeatmapDay>> fetchHistory(HeatmapMetric metric, {int days = 182}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Seed deterministically per metric so switching metrics gives a
    // stable, distinct-looking pattern rather than reshuffling randomly
    // on every rebuild.
    final random = Random(metric.index * 7919);
    final today = DateTime.now();

    return List.generate(days, (i) {
      final date = today.subtract(Duration(days: days - 1 - i));
      final roll = random.nextDouble();
      final level = roll < 0.12
          ? HeatLevel.missed
          : roll < 0.45
              ? HeatLevel.average
              : HeatLevel.excellent;
      return HeatmapDay(date: date, level: level);
    });
  }
}
