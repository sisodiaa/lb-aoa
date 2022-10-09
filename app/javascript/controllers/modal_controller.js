import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"];

  removeModal(event) {
    if (event.params.dismiss || event.detail.success) {
      this.modalTarget.parentElement.removeAttribute("src");
      this.modalTarget.remove();
    }
  }
}
