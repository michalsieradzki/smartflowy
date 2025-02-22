import { Controller } from "@hotwired/stimulus"
import "jquery"
import "select2"

export default class extends Controller {
  connect() {
    console.log('Select2 Controller connected')
    console.log('Element:', this.element)
    this.initSelect2()
  }

  disconnect() {
    console.log('Select2 Controller disconnected')
    if (this.select2Instance) {
      this.select2Instance.destroy()
    }
  }

  initSelect2() {
    console.log('Initializing Select2')
    try {
      this.select2Instance = $(this.element).select2({
        theme: "classic",
        width: '100%',
        placeholder: this.element.getAttribute('placeholder')
      })
      console.log('Select2 initialized successfully')
    } catch (error) {
      console.error('Error initializing Select2:', error)
    }
  }

  formatUser(user) {
    console.log('Formatting user:', user)
    if (!user.id) return user.text;
    
    return $(`
      <div class="d-flex align-items-center">
        <div>
          <div class="font-weight-bold">${user.text}</div>
          ${user.element?.dataset.email ? 
            `<small class="text-muted">${user.element.dataset.email}</small>` : 
            ''}
          ${user.element?.dataset.position ? 
            `<small class="text-muted d-block">${user.element.dataset.position}</small>` : 
            ''}
        </div>
      </div>
    `)
  }
}