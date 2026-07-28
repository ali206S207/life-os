enum DashboardWidgetId { xpBar, assistant, progressRing, todayActions }

extension DashboardWidgetLabel on DashboardWidgetId {
  String get label {
    switch (this) {
      case DashboardWidgetId.xpBar:
        return 'XP & Level';
      case DashboardWidgetId.assistant:
        return 'Assistant';
      case DashboardWidgetId.progressRing:
        return "Today's Progress";
      case DashboardWidgetId.todayActions:
        return "Today's Actions";
    }
  }
}
