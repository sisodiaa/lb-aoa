import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = ["notification"];
  static values = { timeout: Number };
  static classes = [ "topPosition" ]

  notificationTargetConnected() {
    this.notificationTarget.classList.add(this.topPositionClass);

    setTimeout(() => {
      this.close();
    }, this.timeoutValue);
  }

  close() {
    const toast = this.notificationTarget;

    toast.classList.add("opacity-0");
    toast.addEventListener("transitionend", () => {
      toast.remove();
    })
  }
}
