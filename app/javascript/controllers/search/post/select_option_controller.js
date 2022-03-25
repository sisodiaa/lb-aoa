import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search--post--select-option"
export default class extends Controller {
  static targets = ["category"];

  hideModal(e) {
    e.preventDefault();
    this.element.parentElement.removeAttribute("src");
    this.element.remove();
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
