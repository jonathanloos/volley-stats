import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "actionButton", 
    "player", 
    "playerSelection", 
    "actionSelection", 
    "qualitySelection", 
    "clear", 
    "clearButton", 
    "qualityMeasure", 
    "qualityButton", 
    "pointsAgainst", 
    "pointsFor", 
    "submitButton", 
    "undoButton",
    "submissionForm", "playerSubmission", "categorySubmission", "rallySkillSubmission", "skillPointSubmission", "skillErrorSubmission", "skillErrorSubmission", "qualitySubmission", "rotationSubmission"
  ]

  static values = { receiving: {type: Boolean, default: false} }

  connect() { }

  clear () {
    // reset all action buttons
    this.toggleActionButtons()

    // reset all player buttons
    this.togglePlayers()

    // reset all quality metrics
    this.toggleQualitySections()

    // reset all quality buttons
    this.toggleQualityButtons()

    // clear the play outline
    this.clearPlayOutline()

    // hide the clear button
    this.clearButtonTarget.classList.add('d-none')

    // hide submit button
    this.toggleSubmitButton()

    // clear the form values
    this.categorySubmissionTarget.value = ""
    this.playerSubmissionTarget.value = ""
    this.rallySkillSubmissionTarget.value = ""
    this.skillPointSubmissionTarget.value = ""
    this.skillErrorSubmissionTarget.value = ""
    this.qualitySubmissionTarget.value = ""
  }

  submitEvent(event) {
    // adjust score
    this.adjustScore(event.target.dataset.actionType)

    // submit form
    this.submissionFormTarget.requestSubmit()

    // clear all previous values
    this.clear()
  }

  selectActionEvent(event) {
    // disable the rest of the action buttons
    this.toggleActionButtons(event.target)

    // add point for/against to play overview
    this.submitButtonTarget.setAttribute('data-action-type', event.target.dataset.actionType)

    // add action to play overview
    this.actionSelectionTarget.innerHTML = `${event.target.dataset.actionName} (${event.target.dataset.actionType})`

    // update the form accordingly
    this.rallySkillSubmissionTarget.value = ""
    this.skillPointSubmissionTarget.value = ""
    this.skillErrorSubmissionTarget.value = ""
    this.qualitySubmissionTarget.value = ""

    if (event.target.dataset.actionType == "rally_skill") {
      this.rallySkillSubmissionTarget.value = event.target.dataset.enumValue

    } else if (event.target.dataset.actionType == "skill_point") {
      this.skillPointSubmissionTarget.value = event.target.dataset.enumValue

    } else {
      // skill_error
      this.skillErrorSubmissionTarget.value = event.target.dataset.enumValue
    }

    // show quality sections
    this.toggleQualitySections(event.target.dataset.qualityMetric)
    this.qualitySelectionTarget.innerHTML = ""

    // show the clear button
    this.clearButtonTarget.classList.remove('d-none')

    // show submit button
    this.toggleSubmitButton()
  }

  // loop through all buttons and disable them except the activeButton
  // if no action button is passed in enable all buttons
  toggleActionButtons(activeButton) {
    this.actionButtonTargets.forEach(button => {
      if (activeButton === undefined) {
        button.classList.remove("active")

      } else if (button !== activeButton) {
        button.classList.remove("active")

      } else {
        button.classList.add("active")
      }
    })
  }

  selectQualityMetric(event){
    // Disable the rest of the action buttons
    this.toggleQualityButtons(event.target)

    // Add action to play overview
    this.qualitySelectionTarget.innerHTML = `- ${event.target.innerHTML}`

    // Update the form value
    this.qualitySubmissionTarget.value = event.target.innerHTML
  }

  selectPlayer(event) {
    let activePlayer = event.target

    // Weird HTML thing if they click the small tag instead of the li
    if (activePlayer.dataset.name === undefined) {
      activePlayer = event.target.closest('button')
    }

    // Add active class to selected player
    activePlayer.classList.add("active")

    // Disable the rest of the players
    this.togglePlayers(activePlayer)

    // Add players name to play outline
    this.playerSelectionTarget.innerHTML = activePlayer.dataset.name

    // Add the player id to the form
    this.playerSubmissionTarget.value = activePlayer.dataset.id

    // Show the clear button
    this.clearButtonTarget.classList.remove('d-none')

    // Show submit button
    this.toggleSubmitButton()
  }

  togglePlayers(activePlayer) {
    this.playerTargets.forEach(button => {
      if (activePlayer === undefined) {
        button.classList.remove("active")

      } else if (button !== activePlayer) {
        button.classList.remove("active")
      }
    })
  }

  toggleQualityButtons(activeQualityButton) {
    this.qualityButtonTargets.forEach(button => {
      if (activeQualityButton === undefined) {
        button.classList.remove("active")

      } else if (button !== activeQualityButton) {
        button.classList.remove("active")

      } else {
        button.classList.add("active")
      }
    })
  }

  toggleQualitySections(activeQualitySection) {
    this.qualityMeasureTargets.forEach(section => {
      if (activeQualitySection === undefined) {
        section.classList.add("d-none")

      } else if (section.dataset.qualityMetric !== activeQualitySection) {
        section.classList.add("d-none")

      } else {
        section.classList.remove("d-none")
      }
    })
  }

  clearPlayOutline () {
    this.playerSelectionTarget.innerHTML = null
    this.actionSelectionTarget.innerHTML = null
    this.qualitySelectionTarget.innerHTML = null
  }

  adjustScore(type) {
    if (type === "skill_point") {
      this.pointsForTarget.innerHTML = parseInt(this.pointsForTarget.innerHTML) + 1
      this.categorySubmissionTarget.value = "point_earned"

    } else if (type === "skill_error") {
      this.pointsAgainstTarget.innerHTML = parseInt(this.pointsAgainstTarget.innerHTML) + 1
      this.categorySubmissionTarget.value = "point_given"

    } else if (type == "undo") {
      // most recent event
      const most_recent_event = document.getElementById("eventList").firstElementChild

      if (most_recent_event.dataset.pointType == "point_earned") {
        this.pointsForTarget.innerHTML = parseInt(this.pointsForTarget.innerHTML) - 1
      } else if (most_recent_event.dataset.pointType == "point_given") {
        this.pointsAgainstTarget.innerHTML = parseInt(this.pointsAgainstTarget.innerHTML) - 1
      }

    } else {
      this.categorySubmissionTarget.value = "continuation"
    }

    // show undo button
    this.toggleUndoButton()

    // adjust rotation
    this.adjustRotation(type)
  }

  adjustRotation(type) {
    // most recent event
    const most_recent_event = document.getElementById("eventList").firstElementChild
    let pointType = ""

    if (type !== undefined) {
      pointType = type
    } else if (most_recent_event !== null) {
      pointType = most_recent_event.dataset.pointType
    } else {
      return
    }

    // only rotate if you earn a point
    if (pointType == "skill_point") {
      
      // only need the plays with points
      let filteredPlays = []
      for (let child of document.getElementById("eventList").children) {
        if (child.dataset.pointType !== "continuation") {
          filteredPlays.push(child.dataset.pointType)
        }
      }
      filteredPlays = filteredPlays.reverse()

      // if the home team is receiving and win a point, but haven't won any prior points
      if (this.receivingValue == true && filteredPlays.filter(play => play === "point_earned").length === 0) {
        this.rotate()
      } else if (filteredPlays.length >= 2 && filteredPlays[filteredPlays.length - 1] === "point_given") {
        // if the second last point is present and it was a point given
        this.rotate()
      }
    }
  }

  rotate() {
    let nextPlayerNumber = undefined
    let currentPlayerNumber = undefined
    let nextRotationId = undefined
    const rotations = [6, 5, 4, 3, 2, 1]

    // TODO: Rotate back
    rotations.forEach(rotation => {

      // need to wrap back to 6 when in rotation 1
      if (rotation === 1) {
        nextRotationId = "rotation6"
      } else {
        nextRotationId = `rotation${rotation - 1}`
      }

      // save the next rotations number because we're going to override it
      nextPlayerNumber = document.getElementById(nextRotationId).innerHTML

      // on the first iteration set the currentPlayerNumber
      if (currentPlayerNumber === undefined) {
        currentPlayerNumber = document.getElementById(`rotation${rotation}`).innerHTML
      }

      // set the current number to the next position
      document.getElementById(nextRotationId).innerHTML = currentPlayerNumber

      // set the current number as the next rotations number
      currentPlayerNumber = nextPlayerNumber
    })
  }

  undoAction() {
    // adjust the score
    this.adjustScore("undo")

    // hide/show undo button
    this.toggleUndoButton()
  }

  toggleUndoButton() {
    const undoButton = document.getElementById("undoButton")
    const playsCount = document.getElementById("eventList").childElementCount

    if (playsCount > 0) {
      undoButton.classList.remove("d-none")
    } else {
      undoButton.classList.add("d-none")
    }
  }

  toggleSubmitButton() {
    // Check if both a player and an action have been selected
    if (this.playerSelectionTarget.innerHTML !== "" && this.actionSelectionTarget.innerHTML !== "") {
      this.submitButtonTarget.classList.remove("d-none")
    } else {
      this.submitButtonTarget.classList.add("d-none")
    }
  }
}
