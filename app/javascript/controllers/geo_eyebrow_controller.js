import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    fetch("https://ipapi.co/json/")
      .then((response) => response.json())
      .then((data) => {
        const country = data && data.country_code

        if (country === "CA") {
          this.element.textContent = "Launching across Canada & the U.S."
        } else if (country === "US") {
          this.element.textContent = "Launching across the US & Canada."
        }
        // Any other country: leave "Launching soon." as-is.
      })
      .catch(() => {
        // Network failure, blocked request, etc. — leave the default text.
      })
  }
}