document.addEventListener("turbo:load", () => {
  const cmsEditor = document.querySelector("trix-editor#post__content");
  cmsEditor &&
    cmsEditor.addEventListener("trix-file-accept", (event) => {
      const maxFileSize = 1024 * 1024 * 5; // 1MB
      if (event.file.size > maxFileSize) {
        event.preventDefault();
        alert("Only support attachment files upto size 5 MB!");
      }
    });

  const tmsEditor = document.querySelector("trix-editor#tender__description");
  tmsEditor &&
    delete tmsEditor.dataset.directUploadUrl &&
    delete tmsEditor.dataset.blobUrlTemplate &&
    delete tmsEditor.dataset.directUploadAttachmentName &&
    delete tmsEditor.dataset.directUploadToken &&
    tmsEditor.addEventListener("trix-file-accept", (event) => {
      event.preventDefault();
      alert("File attachments in Tender's editor are not allowed");
    });
});
