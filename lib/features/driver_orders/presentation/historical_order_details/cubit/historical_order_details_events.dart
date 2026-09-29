sealed class HistoricalOrderDetailsEvent {
  const HistoricalOrderDetailsEvent();
}

class GetHistoricalOrderDetailsEvent extends HistoricalOrderDetailsEvent {
  final String orderId;
  const GetHistoricalOrderDetailsEvent(this.orderId);
}
