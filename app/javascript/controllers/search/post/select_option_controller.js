import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search--post--select-option"
export default class extends Controller {
  static targets = ["category", "modal", "form"];

  hideModal(e) {
    if (e.type === "click") {
      e.preventDefault();
    }

    this.modalTarget.parentElement.removeAttribute("src");
    this.modalTarget.remove();
  }

  deactivateForm() {
    this.formTarget.classList.add("opacity-50", "pointer-events-none");
  }

  activateForm() {
    this.formTarget.classList.remove("opacity-50", "pointer-events-none");
  }

  categoryTargetConnected(element) {
    if (element.value !== "") {
      const opt = document.createElement("option");
      opt.value = "";
      opt.text = "All Categories";

      element.add(opt, element.options[0]);
    }
  }
}
