sealed class DriverOrderHistoryEvent {
  const DriverOrderHistoryEvent();
}

class GetDriverOrderHistoryEvent extends DriverOrderHistoryEvent {
  final int page;
  final int pageSize;
  final String? status;

  const GetDriverOrderHistoryEvent({
    this.page = 1,
    this.pageSize = 20,
    this.status,
  });
}

class RefreshOrderHistoryEvent extends DriverOrderHistoryEvent {
  const RefreshOrderHistoryEvent();
}
