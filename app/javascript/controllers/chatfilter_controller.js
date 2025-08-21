import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chatfilter"
export default class extends Controller {
  static targets = ["searchbar", "searchchats"]
  connect() {
  }

  filter() {
    const searchTerm = this.searchbarTarget.value;
    console.log("Okay seaching here");
    this.searchchatsTargets.forEach((chat) => {
      const receiver = chat.getAttribute("data-key");
      const isMatch = receiver.startsWith(searchTerm);
      chat.style.display = isMatch ? "" : "none";
    })
  }
}
