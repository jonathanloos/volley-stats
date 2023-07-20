import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["actionButton", "player", "playerSelection", "actionSelection", "qualitySelection"]

  connect() { }

  selectActionEvent(event) {
    // Disable the rest of the rally buttons
    this.disableActionButtons(event.target)

    // Add action to overview sentence
    this.actionSelectionTarget.innerHTML = `${event.target.dataset.actionName} (${event.target.dataset.actionType}) `

    // Disable inapplicable quality sections
  }

  // loop through all buttons and disable them except the activeButton
  disableActionButtons(activeButton) {
    this.actionButtonTargets.forEach(button => {
      if (button !== activeButton) {
        button.classList.add("disabled")
      }
    })
  }

  selectPlayer(event) {
    let activePlayer = event.target

    // Weird HTML thing if they click the small tag instead of the li
    if (event.target.dataset.name === undefined) {
      activePlayer = event.target.parentElement
    }

    // Add active class to selected player
    activePlayer.classList.add("active")

    // Disable the rest of the players
    this.disablePlayers(activePlayer)

    // Add players name to play outline
    this.playerSelectionTarget.innerHTML = activePlayer.dataset.name
  }

  disablePlayers(activePlayer) {
    this.playerTargets.forEach(button => {
      if (button !== activePlayer) {
        button.classList.add("disabled")
      }
    })
  }
}
