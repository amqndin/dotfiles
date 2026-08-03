import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Item {
    IpcHandler {
        function follow(): string {
            var popups = NotificationService.visibleNotifications;
            if (popups && popups.length > 0) {
                var latest = popups[popups.length - 1];
                if (latest.actions && latest.actions.length > 0) {
                    latest.actions[0].invoke();
                    latest.popup = false;
                    return "FOLLOW_SUCCESS";
                }
            }
            var center = NotificationService.notifications;
            if (center && center.length > 0) {
                var latest = center[center.length - 1];
                if (latest.actions && latest.actions.length > 0) {
                    latest.actions[0].invoke();
                    return "FOLLOW_SUCCESS";
                }
            }
            return "ERROR: No notification with actions available";
        }
        target: "notif-follow"
    }
}
