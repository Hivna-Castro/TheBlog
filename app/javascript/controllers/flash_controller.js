import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.timeout = 5000;
    this.hideMessagesAfterTimeout();
  }

  hideMessagesAfterTimeout() {
    setTimeout(() => {
      this.element.querySelectorAll(".flash-message").forEach((message) => {
        message.remove();
      });
    }, this.timeout);
  }
}
