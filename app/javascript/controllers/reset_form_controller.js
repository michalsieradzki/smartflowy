import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset() {
    this.element.reset()
    this.element.closest('turbo-frame').innerHTML = ""
  }
  
  cancel(event) {
    event.preventDefault()
    this.element.closest('turbo-frame').innerHTML = ""
  }
}