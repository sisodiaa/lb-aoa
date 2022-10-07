import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="element-removal"
export default class extends Controller {
  static targets = ["element"];

  hide() {
    this.elementTarget.classList.add("opacity-0");
  }

  remove(event) {
    if (event.propertyName === "opacity") {
      this.elementTarget.remove();
    }
  }
}
