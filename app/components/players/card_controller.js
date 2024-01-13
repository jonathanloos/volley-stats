import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['statButton', 'form', 'categorySubmission', 'rallySkillSubmission', 'skillPointSubmission', 'skillErrorSubmission', 'qualitySubmission']

  connect() { 
    let timerId = null

    this.statButtonTargets.forEach(target => {
      target.addEventListener('click', (event) => {
        if (timerId) {
          clearTimeout(timerId)
          // submit the form
        }

        timerId = setTimeout(() => {
          // submit the form
          this.submit(event)
        }, 400);
      })
    })
  }

  submit (event) {
    this.categorySubmissionTarget.value = event.target.dataset.category

    this.statButtonTargets.forEach(target => {
      target.checked = false
    })
  }
}