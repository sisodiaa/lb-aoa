import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flowbite--collapse"
export default class extends Controller {
  static targets = [ "menu" ]

  toggle() {
    const show = this.menuTarget.classList.contains("hidden");

    if (show) {
      this.menuTarget.classList.remove("hidden");
    } else {
      this.menuTarget.classList.add("hidden");
    }
  }

}
