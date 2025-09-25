from src.services import metrics


def test_metrics_counters_increment():
    metrics.events_received_total.inc()
    metrics.events_stored_total.inc()
    metrics.notifications_sent_total.inc()
    metrics.notifications_failed_total.inc()
    # No assertion on value; ensure no exceptions raised
    assert True
