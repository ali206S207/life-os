import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/heatmap_repository.dart';
import '../../domain/heatmap_day.dart';

final heatmapRepositoryProvider = Provider<HeatmapRepository>((ref) {
  return LocalHeatmapRepository();
});

/// The currently selected metric for the heatmap (Workout, Study, ...).
class SelectedHeatmapMetricNotifier extends Notifier<HeatmapMetric> {
  @override
  HeatmapMetric build() => HeatmapMetric.workout;

  void select(HeatmapMetric metric) => state = metric;
}

final selectedHeatmapMetricProvider =
    NotifierProvider<SelectedHeatmapMetricNotifier, HeatmapMetric>(
  SelectedHeatmapMetricNotifier.new,
);

/// History for whichever metric is currently selected. Automatically
/// re-fetches when the selected metric changes.
final heatmapHistoryProvider = FutureProvider<List<HeatmapDay>>((ref) {
  final metric = ref.watch(selectedHeatmapMetricProvider);
  return ref.read(heatmapRepositoryProvider).fetchHistory(metric);
});
