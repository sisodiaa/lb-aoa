import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = ["notificationsContainer", "notification"];
  static values = { timeout: Number };
  static classes = [ "topPosition" ]

  close(toast) {
    toast.classList.add("opacity-0");
    toast.addEventListener("transitionend", () => {
      toast.remove();
    });
  }

  // Callbacks
  notificationsContainerTargetConnected(container) {
    container.classList.add(this.topPositionClass);
  }

  notificationTargetConnected(toast) {
    setTimeout(() => {
      this.close(toast);
    }, this.timeoutValue);
  }

  notificationTargetDisconnected() {
    if (!this.hasNotificationTarget) {
      this.notificationsContainerTarget.remove();
    }
  }

  // Actions
  discard(event) {
    this.close(event.currentTarget.parentElement);
  }
}
