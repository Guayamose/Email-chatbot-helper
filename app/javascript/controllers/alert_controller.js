import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

// Connects to data-controller="alert"
export default class extends Controller {
  static targets = ["link"]
  show(e) {
    e.preventDefault()
    console.log("the show is working...");
    Swal.fire({
      title: "Are you sure?",
      text: "You won't be able to revert this!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#607466",
      cancelButtonColor: "#D7816A",
      confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
          this.linkTarget.click()
        }
      });
  }

  confirmLogout(event) {
    event.preventDefault()

    const link = event.currentTarget

    Swal.fire({
      title: "Logout?",
      text: "You will need to login again to continue chatting",
      icon: "question",
      showCancelButton: true,
      confirmButtonText: "Yes, log out"
    }).then((result) => {
      if (result.isConfirmed) {
        link.removeAttribute("data-action")

        setTimeout(() => {
          link.click()
        }, 0)
      }
    })
  }
}
