import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

// Connects to data-controller="dashboard--list"
export default class extends Controller {
  static targets = ["list", "item"];
  static values = {
    source: String,
    item: String,
  };

  connect() {
    if (!this.sourceValue) {
      this.sourceValue = window.location.href;
    }
  }

  markItem(event) {
    console.log("marked");
    const item = event.currentTarget.parentElement.parentElement.parentElement;
    this.itemValue = item.id;
  }

  itemTargetDisconnected(element) {
    if (element.id === this.itemValue) {
      this.removeItem();
      this.listTarget.classList.add("opacity-50", "pointer-events-none");
    }
  }

  async removeItem() {
    const response = await get(this.sourceValue, {
      responseKind: "turbo-stream",
    });

    if (response.ok) {
      this.listTarget.classList.remove("opacity-50", "pointer-events-none");
    }
  }
}
