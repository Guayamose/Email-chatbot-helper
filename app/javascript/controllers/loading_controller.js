import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["area"]
  connect() {
    console.log('connected1312');

  }

  start() {
    console.log("start");

    this.showLoading();
  }

  showLoading() {
    if (this.hasAreaTarget) {
      this.areaTarget.innerHTML = `
        <div class="d-flex justify-content-center align-items-center p-3">
          <i class="fa-solid fa-spinner fa-spin"></i>
        </div>
      `
    }
  }
}
