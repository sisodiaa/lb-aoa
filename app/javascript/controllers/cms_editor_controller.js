import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cms-editor"
export default class extends Controller {
  connect() {
    delete this.element.dataset.directUploadUrl;
    delete this.element.dataset.blobUrlTemplate;
    delete this.element.dataset.directUploadAttachmentName;
    delete this.element.dataset.directUploadToken;

    [
      ".trix-button-group--file-tools",
      ".trix-button--icon-code",
    ].forEach((query) => {
      const el = document.querySelector(query);
      el && el.remove();
    });
  }

  disableAccept(event) {
    event.preventDefault();
    alert("Drag and Drop is not supported.");
  }
}
