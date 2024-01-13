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
    this.rallySkillSubmissionTarget.value = event.target.dataset.rallySkill
    this.skillPointSubmissionTarget.value = event.target.dataset.skillPoint
    this.skillErrorSubmissionTarget.value = event.target.dataset.skillError
    this.qualitySubmissionTarget.value = event.target.dataset.quality

    console.log("Submitting:")
    console.log("Category: ", this.categorySubmissionTarget.value)
    console.log("RallySkill: ", this.rallySkillSubmissionTarget.value)
    console.log("SkillPoint: ", this.skillPointSubmissionTarget.value)
    console.log("SkillError: ", this.skillErrorSubmissionTarget.value)
    console.log("Quality: ", this.qualitySubmissionTarget.value)
    this.statButtonTargets.forEach(target => {
      target.checked = false
    })
  }
}