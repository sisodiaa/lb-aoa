document.addEventListener('turbo:load', () => {
  // Toggle target elements using [data-collapse-toggle]
  document.querySelectorAll('[data-collapse-toggle]').forEach(function (collapseToggleEl) {
    var collapseId = collapseToggleEl.getAttribute('data-collapse-toggle');
    collapseToggleEl.addEventListener('click', function () {
      toggleCollapse(collapseId, document.getElementById(collapseId).classList.contains('hidden'));
    });
  });
});

document.addEventListener('DOMContentLoaded', () => {
  // Toggle target elements using [data-collapse-toggle]
  document.querySelectorAll('[data-collapse-toggle]').forEach(function (collapseToggleEl) {
    var collapseId = collapseToggleEl.getAttribute('data-collapse-toggle');
    collapseToggleEl.addEventListener('click', function () {
      toggleCollapse(collapseId, document.getElementById(collapseId).classList.contains('hidden'));
    });
  });
});
