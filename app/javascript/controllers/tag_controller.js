import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["name", "file"];

  connect() {
    this.toggleFields();
  }

  toggleFields() {
    const isNameFilled = this.nameTarget.value.trim() !== "";
    const isFileSelected = this.fileTarget.value !== "";

    this.fileTarget.disabled = isNameFilled;
    this.nameTarget.disabled = isFileSelected;
  }

  onInput() {
    this.toggleFields();
  }

  onFileChange() {
    this.toggleFields();
  }
}
