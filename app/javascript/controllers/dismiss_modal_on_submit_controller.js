import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modal', 'form']

  connect() {
    this.formTargets.forEach(formTarget => {
      formTarget.addEventListener('submit', (event) => {
        const modal = bootstrap.Modal.getInstance(this.modalTarget)
        modal.hide()
      })
    })
  }
}