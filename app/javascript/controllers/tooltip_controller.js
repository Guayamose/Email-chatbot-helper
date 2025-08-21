import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tooltip"
export default class extends Controller {
  connect() {
    const button = this.element
    if (button.dataset.bsToggle == "tooltip") {
      new bootstrap.Tooltip(button)
    }
  }
}
