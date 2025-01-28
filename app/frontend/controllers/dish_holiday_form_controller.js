import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dish-holiday-form"
export default class extends Controller {
  static targets = ["newDishField", "newHolidayField"];

  connect() {
    console.log("Dish-Holiday Form Controller connected.");
  }

  addNewDish(event) {
    const selectedValue = event.target.value;

    if (selectedValue) {
      this.newDishFieldTarget.value = ""; // Clear new dish field
      this.newDishFieldTarget.disabled = true; // Disable the input if a dish is selected
    } else {
      this.newDishFieldTarget.disabled = false; // Enable the input for a new dish
    }
  }

  addNewHoliday(event) {
    const selectedValue = event.target.value;

    if (selectedValue) {
      this.newHolidayFieldTarget.value = ""; // Clear new holiday field
      this.newHolidayFieldTarget.disabled = true; // Disable the input if a holiday is selected
    } else {
      this.newHolidayFieldTarget.disabled = false; // Enable the input for a new holiday
    }
  }
}
