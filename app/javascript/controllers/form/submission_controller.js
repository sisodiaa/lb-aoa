import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form--submission"
export default class extends Controller {
  deactivate() {
    this.element.classList.add("opacity-50", "pointer-events-none");
  }

  activate() {
    this.element.classList.remove("opacity-50", "pointer-events-none");
  }
}
