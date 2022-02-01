import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard--component"
export default class extends Controller {
  static values = { title: String }
  static targets = ["header", "toggleButton", "lists"]

  toggle(event) {
    event.preventDefault();

    this.headerTarget.classList.toggle("mb-6");
    this.listsTarget.classList.toggle("hidden");

    if (this.titleValue === "posts") {
      if (this.toggleButtonTarget.innerHTML === "Show Posts") {
        this.toggleButtonTarget.innerHTML = "Hide Posts";
      } else {
        this.toggleButtonTarget.innerHTML = "Show Posts";
      }
    }
  }
}
