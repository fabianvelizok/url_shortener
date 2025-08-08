import { Controller } from "@hotwired/stimulus"
  
export default class extends Controller {
  static values = {
    content: String,
    successMessage: { type: String, default: "Copied!" },
    errorMessage: { type: String, default: "Failed!" }
  }

  tooltip(message) {
    tippy(this.element, {
      content: message,
      showOnCreate: true,
      onHidden: (instance) => {
        instance.destroy();
      }
    })
  }

  async copy() {
    try {
      const text = this.contentValue || ""
      await navigator.clipboard.writeText(text)
      this.tooltip(this.successMessageValue)
    } catch (error) {
      this.tooltip(this.errorMessageValue)
    }
  }
}
