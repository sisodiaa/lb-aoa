document.addEventListener("turbo:load", () => {
  const trixEditor = document.querySelector("trix-editor");
  trixEditor &&
    trixEditor.addEventListener("trix-file-accept", (event) => {
      const maxFileSize = 1024 * 1024 * 5; // 1MB
      if (event.file.size > maxFileSize) {
        event.preventDefault();
        alert("Only support attachment files upto size 5 MB!");
      }
    });
});
