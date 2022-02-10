document.addEventListener('turbo:load', () => {
  const cmsEditor = document.querySelector("trix-editor#post__content");
  if (cmsEditor) {
    const el = document.querySelector('.trix-button--icon-code')
    el && el.remove();
  }

  const tmsEditor = document.querySelector("trix-editor#tender__description");
  if (tmsEditor) {
    [
      '.trix-button-group--file-tools',
      '.trix-button--icon-code'
    ].forEach((query) => {
      const el = document.querySelector(query);
      el && el.remove();
    });
  }
})
