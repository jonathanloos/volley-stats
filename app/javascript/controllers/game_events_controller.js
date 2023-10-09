import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["actionButton", "player", "playerSelection", "actionSelection", "qualitySelection", "clear", "clearButton", "qualityMeasure", "qualityButton", "pointsAgainst", "pointsFor", "submitButton", "rotation", "undoButton"]

  static values = { plays: {type: Array, default: []} }

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
  }

  submitEvent(event) {
    // post the event to the controller

    // adjust score
    this.adjustScore(event.target.dataset.actionType)

    // clear all previous values
    this.clear()

    // update rotation
    // update server?
  }

  selectActionEvent(event) {
    // disable the rest of the action buttons
    this.toggleActionButtons(event.target)

    // add point for/against to play overview
    this.submitButtonTarget.setAttribute('data-action-type', event.target.dataset.actionType)

    // add action to play overview
    this.actionSelectionTarget.innerHTML = `${event.target.dataset.actionName} (${event.target.dataset.actionType})`

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
  }

  selectPlayer(event) {
    let activePlayer = event.target

    // Weird HTML thing if they click the small tag instead of the li
    if (activePlayer.dataset.name === undefined) {
      activePlayer = event.target.parentElement
    }

    // Add active class to selected player
    activePlayer.classList.add("active")

    // Disable the rest of the players
    this.togglePlayers(activePlayer)

    // Add players name to play outline
    this.playerSelectionTarget.innerHTML = activePlayer.dataset.name

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
    
    if (type === "point") {
      this.pointsForTarget.innerHTML = parseInt(this.pointsForTarget.innerHTML) + 1
      this.playsValue.push({play_type: 'pointFor'})

    } else if (type === "error") {
      this.pointsAgainstTarget.innerHTML = parseInt(this.pointsAgainstTarget.innerHTML) + 1
      this.playsValue.push({play_type: 'pointAgainst'})

    } else if (type == "undo") {
      const most_recent_play = this.playsValue[this.playsValue.length - 1].play_type

      if (most_recent_play == "pointFor") {
        this.pointsForTarget.innerHTML = parseInt(this.pointsForTarget.innerHTML) - 1
      } else if (most_recent_play == "pointAgainst") {
        this.pointsAgainstTarget.innerHTML = parseInt(this.pointsAgainstTarget.innerHTML) - 1
      }

    } else {
      this.playsValue.push({play_type: 'rally'})
    }

    // show undo button
    this.toggleUndoButton()

    // adjust rotation
    this.adjustRotation()
  }

  adjustRotation() {
    if (this.playsValue.length >= 2 && this.playsValue[this.playsValue.length - 1].play_type === "pointFor") {
      const filteredPlays = this.playsValue.filter(play => play.play_type !== "rally")

      if (filteredPlays.length >= 2 && filteredPlays[filteredPlays.length - 2].play_type === "pointAgainst") {
        if (parseInt(this.rotationTarget.innerHTML) == 1) {
          this.rotationTarget.innerHTML = 6
        } else {
          this.rotationTarget.innerHTML = parseInt(this.rotationTarget.innerHTML) - 1
        }
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

    // remove most recent play
    this.playsValue.pop()

    // hide/show undo button
    this.toggleUndoButton()
  }

  toggleUndoButton() {
    if (this.playsValue.length > 0) {
      this.undoButtonTarget.classList.remove("d-none")
    } else {
      this.undoButtonTarget.classList.add("d-none")
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
