document.addEventListener("turbo:load", () => {
  const trixEditor = document.querySelector("trix-editor");
  trixEditor &&
    trixEditor.addEventListener("trix-file-accept", (event) => {
      const acceptedTypes = ["image/jpeg", "image/png"];
      if (!acceptedTypes.includes(event.file.type)) {
        event.preventDefault();
        alert("Only support attachment of jpeg or png files");
      }
    });
});
