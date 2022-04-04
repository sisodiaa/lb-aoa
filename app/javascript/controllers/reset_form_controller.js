import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-form"
export default class extends Controller {
  deactivateForm() {
    this.element.classList.add("opacity-50", "pointer-events-none");
  }

  activateForm() {
    this.element.classList.remove("opacity-50", "pointer-events-none");
  }
}
