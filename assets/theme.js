(function () {
  var storageKey = 'ios-kb-theme';
  var root = document.documentElement;

  function systemTheme() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function apply(theme) {
    root.setAttribute('data-theme', theme);
  }

  function savedTheme() {
    try {
      return localStorage.getItem(storageKey);
    } catch (error) {
      return null;
    }
  }

  function persist(theme) {
    try {
      localStorage.setItem(storageKey, theme);
    } catch (error) {
      /* private browsing */
    }
  }

  apply(savedTheme() || systemTheme());

  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (event) {
    if (!savedTheme()) {
      apply(event.matches ? 'dark' : 'light');
    }
  });

  document.addEventListener('DOMContentLoaded', function () {
    var button = document.getElementById('theme-toggle');
    if (!button) {
      return;
    }
    button.addEventListener('click', function () {
      var next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      apply(next);
      persist(next);
    });
  });
})();
