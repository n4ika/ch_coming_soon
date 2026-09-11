import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { email: String }

  connect() {
    if (typeof klaviyo === "undefined") return // tracking snippet blocked or not loaded — fail quietly

    klaviyo.identify({
      email: this.emailValue
    })
  }
}
