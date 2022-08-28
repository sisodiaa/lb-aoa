import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="owners--dashboards--tab"
export default class extends Controller {
  static targets = ["item"];
  static values = { index: Number };

  select(event) {
    this.indexValue = event.params.id;
  }

  indexValueChanged() {
    this.activateCurrentTab()
  }

  activateCurrentTab() {
    this.itemTargets.forEach((element, index) => {
      const link = element.children[0];

      if (index === this.indexValue) {
        link.classList.remove("hover:text-lb-600", "hover:bg-fuchsia-50");
        link.classList.add("text-lb-600", "bg-fuchsia-100", "active");
      } else {
        link.classList.add("hover:text-lb-600", "hover:bg-fuchsia-50");
        link.classList.remove("text-lb-600", "bg-fuchsia-100", "active");
      }
    });
  }
}
