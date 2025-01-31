import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["newDishField", "newHolidayField"];

  connect() {
    console.log("Dish-Holiday Form Controller connected.");
  }

  addNewDish(event) {
		const selectedValue = event.target.value;
    if (selectedValue) {
      this.newDishFieldTarget.value = "";
      this.newDishFieldTarget.disabled = true;
    } else {
      this.newDishFieldTarget.disabled = false;
    }
  }

  addNewHoliday(event) {
    const selectedValue = event.target.value;
    if (selectedValue) {
      this.newHolidayFieldTarget.value = "";
      this.newHolidayFieldTarget.disabled = true;
    } else {
      this.newHolidayFieldTarget.disabled = false;
    }
  }
}
