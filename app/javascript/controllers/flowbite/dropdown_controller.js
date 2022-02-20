import { createPopper } from '@popperjs/core';
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flowbite--dropdown"
export default class extends Controller {
  static values = { placement: String }
  static targets = [ "dropdown", "menu" ]

  toggle(event) {
    let element = event.target;

    while (element.nodeName !== "BUTTON") {
      element = element.parentNode;
    }

    createPopper(element, this.menuTarget, {
      placement: this.hasPlacementValue ? this.placementValue : "bottom-start",
      modifiers: [
        {
          name: "offset",
          options: {
            offset: [0, 10]
          }
        }
      ]
    })

    this.menuTarget.classList.toggle('hidden');
    this.menuTarget.classList.toggle('block');
  }

  hide(event) {
    if (event && this.dropdownTarget.contains(event.target)) {
      return;
    }
    
    this.menuTarget.classList.add('hidden');
    this.menuTarget.classList.remove('block');
  }

  select() {
    this.menuTarget.classList.add('hidden');
    this.menuTarget.classList.remove('block');
  }
}
