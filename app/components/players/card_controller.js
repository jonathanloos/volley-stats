import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['statButton', 'form', 'categorySubmission', 'rallySkillSubmission', 'skillPointSubmission', 'skillErrorSubmission', 'qualitySubmission']

  connect() { }

  submit (event) {
    this.categorySubmissionTarget.value = event.target.dataset.category ?? ""
    this.rallySkillSubmissionTarget.value = event.target.dataset.rallySkill ?? ""
    this.skillPointSubmissionTarget.value = event.target.dataset.skillPoint ?? ""
    this.skillErrorSubmissionTarget.value = event.target.dataset.skillError ?? ""
    this.qualitySubmissionTarget.value = event.target.dataset.quality ?? ""

    this.formTarget.requestSubmit()

    setTimeout(() => {
      this.statButtonTargets.forEach(target => {
        target.checked = false
      })
    }, 400);
  }
}