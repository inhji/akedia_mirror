document.addEventListener('DOMContentLoaded', function() {
  const searchBar = document.querySelector('.search-bar');
  const searchInput = document.querySelector('.search-bar input.search-input')

  searchBar.addEventListener('focusin', () => searchInput.focus());
  searchBar.addEventListener('focusout', () => searchInput.value = "")
})
