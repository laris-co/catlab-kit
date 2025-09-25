from __future__ import annotations

from prometheus_client import Counter

events_received_total = Counter(
    "events_received_total", "Inbound webhook events received"
)
events_stored_total = Counter("events_stored_total", "Webhook events persisted")
notifications_sent_total = Counter(
    "notifications_sent_total", "Outbound notifications sent successfully"
)
notifications_failed_total = Counter(
    "notifications_failed_total", "Outbound notifications that failed"
)
