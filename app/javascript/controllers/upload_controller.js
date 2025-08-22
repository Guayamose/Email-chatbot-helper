import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = ["label", "input"];

  showSelected(event) {
    const files = this.inputTarget.files
    console.log(files);
    if (files.length > 0) {
      const names = Array.from(files).map(file => file.name).join(", ")
      this.labelTarget.textContent = `${names} ✅`
    } else {
      this.labelTarget.textContent = ""
    }
  }
}
