import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = ["notification"];

  connect() {
    setTimeout(() => {
      this.close();
    }, 5000);
  }

  close() {
    const toast = this.notificationTarget;

    toast.classList.add("opacity-0");
    toast.addEventListener("transitionend", () => {
      toast.remove();
    })
  }
}
