import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messagenavbar"
export default class extends Controller {
  connect() {
  }

  messageClick(e) {
    e.preventDefault();
    const link = e.currentTarget;
    const element = document.getElementById(`message_${link.dataset.messageid}`);
    const messageArea = document.querySelector('.message-area');
    const offsetTop = element.offsetTop - messageArea.offsetTop;

    messageArea.scrollTop = offsetTop;
    const offcanvasmessagenavbar = document.getElementById("offcanvasmessagenavbar");
    const bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(offcanvasmessagenavbar);
    bsOffcanvas.hide();
  }
}
