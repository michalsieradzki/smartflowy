import { Controller } from "@hotwired/stimulus"
import "jquery"
import "select2"

export default class extends Controller {
  connect() {
    this.initSelect2()
  }

  // disconnect() {
  //   if (this.select2Instance) {
  //     this.select2Instance.destroy()
  //   }
  // }

  initSelect2() {
    this.select2Instance = $(this.element).select2({
      theme: "classic",
      width: '100%',
      placeholder: this.element.getAttribute('placeholder')
    })
  }

  formatUser(user) {
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