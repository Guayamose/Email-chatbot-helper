import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="email-modal"
export default class extends Controller {
  static targets = ["modal", "receiver", "subject", "user", "message", "textarea"]
  open(event) {

    event.preventDefault();
    const button = event.currentTarget;
    this.userTarget.innerHTML = `<p><strong>From:</strong> ${button.dataset.user}</p>`;;
    this.receiverTarget.innerHTML = `<p><strong>To:</strong> ${button.dataset.receiver}</p>`;
    this.subjectTarget.innerHTML = `<p><strong>Subject:</strong> ${button.dataset.subject}</p>`;
    this.messageTarget.innerHTML = button.dataset.message;
    this.formTarget = button.closest("form");
    this.textareaTarget.value = "";
    this.modalTarget.style.display = "block";

    console.log(button.dataset.user);
  }

  close() {
    this.modalTarget.style.display = "none"
  }

   confirm() {
    const token = document.querySelector("meta[name='csrf-token']").content
    const url = '/sendmail'

    const formData = new FormData()
    formData.append("message_content", this.textareaTarget.value);
    formData.append("receiver", this.receiverTarget.textContent.replace("To: ", ""));
    formData.append("user", this.userTarget.textContent.replace("From: ", ""));
    formData.append("subject", this.subjectTarget.textContent.replace("Subject: ", ""));

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": token
      },
      body: formData
    })
    .then(response => response.json())
    .then(
      this.close()
    )
    .catch(e => console.error(e))
  }
}
