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

  deactivateForm() {
    this.formTarget.classList.add("opacity-50", "pointer-events-none");
  }

  activateForm() {
    this.formTarget.classList.remove("opacity-50", "pointer-events-none");
  }

  removeModal() {
    if (this.hasModalTarget) {
      this.modalTarget.parentElement.removeAttribute("src");
      this.modalTarget.remove();
    }
  }
}
