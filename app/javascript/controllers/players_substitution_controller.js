import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['submitButton', 'modal', 'form']

  connect() {
    this.formTarget.addEventListener('submit', (event) => {
      const modal = bootstrap.Modal.getInstance(this.modalTarget)
      modal.hide()
    })
  }
}