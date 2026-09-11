// Swaps the hero eyebrow text based on the visitor's country, detected via
// a client-side IP geolocation lookup (ipapi.co — no API key needed on
// their free tier: 30k requests/month, HTTPS supported).
//
// The HTML default is "Launching soon." (the generic, safe copy) so
// nothing incorrect shows before this resolves — or if it fails entirely,
// which IP geolocation calls sometimes do (ad blockers, privacy extensions,
// and some corporate networks block third-party lookup services like this
// one). Failing silently back to the default is intentional.
//
// If Stimulus controllers aren't auto-registering in your app, add this to
// app/javascript/controllers/index.js:
//   import GeoEyebrowController from "./geo_eyebrow_controller"
//   application.register("geo-eyebrow", GeoEyebrowController)
// Most Rails 8 apps generated with the default Stimulus setup don't need
// this — they eager-load every *_controller.js file in this directory
// automatically.

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