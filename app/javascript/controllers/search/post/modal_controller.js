import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search--post--modal"
export default class extends Controller {
  static targets = ["modal", "form"];

  connect() {
    document.addEventListener("turbo:before-visit", () => {
      this.removeModal();
    });
  }

  hideModal(e) {
    if (e.type === "click") {
      e.preventDefault();
    }

    this.removeModal();
  }

  removeModal(e) {
    if (
      e &&
      (this.formTarget.contains(e.target) ||
        this.formTarget.parentElement.contains(e.target))
    ) {
      return;
    }

    if (this.hasModalTarget) {
      this.modalTarget.parentElement.removeAttribute("src");
      this.modalTarget.remove();
    }
  }
}
