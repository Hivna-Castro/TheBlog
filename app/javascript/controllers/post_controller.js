import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title", "content", "file"];

  connect() {
    this.toggleFields();
  }

  toggleFields() {
    const isTitleOrContentFilled =
      this.titleTarget.value.trim() !== "" ||
      this.contentTarget.value.trim() !== "";
    const isFileSelected = this.fileTarget.value !== "";

    this.fileTarget.disabled = isTitleOrContentFilled;

    this.titleTarget.disabled = isFileSelected;
    this.contentTarget.disabled = isFileSelected;
  }

  onInput() {
    this.toggleFields();
  }

  onFileChange() {
    this.toggleFields();
  }
}
