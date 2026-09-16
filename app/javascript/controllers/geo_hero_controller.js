import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["eyebrow", "image"];

  connect() {
    fetch("https://ipapi.co/json/")
      .then((response) => response.json())
      .then((data) => {
        const country = data && data.country_code;
        this.updateEyebrow(country);
        this.updateImage(country);
      })
      .catch(() => {
        // Network failure, blocked request, etc. — leave both defaults as-is.
      });
  }

  updateEyebrow(country) {
    if (!this.hasEyebrowTarget) return;

    if (country === "CA") {
      this.eyebrowTarget.textContent = "Launching across Canada & the U.S.";
    } else if (country === "US") {
      this.eyebrowTarget.textContent = "Launching across the US & Canada.";
    }
    // Any other country: leave "Launching soon." as-is.
  }

  updateImage(country) {
    if (!this.hasImageTarget) return;

    if (country === "CA" && this.imageTarget.dataset.caSrc) {
      this.imageTarget.src = this.imageTarget.dataset.caSrc;
    } else if (country === "US" && this.imageTarget.dataset.usSrc) {
      this.imageTarget.src = this.imageTarget.dataset.usSrc;
    }
    // Any other country, or if a variant file doesn't exist yet: leave the
    // default mascot image as-is (the `if` guards above check the data
    // attribute is actually present, so this fails safe even before the
    // real CA/US art exists).
  }
}
