import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cms--visibility-toggle"
export default class extends Controller {
  static targets = [ "form" ]

  submit() {
    this.formTarget.requestSubmit()
  }
}
