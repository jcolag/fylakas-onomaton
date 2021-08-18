function toggleDark(isDark) {
  if (isDark) {
    localStorage.setItem('fo-dark-mode', 'dark-mode');
  } else {
    localStorage.setItem('fo-dark-mode', '');
  }
  setDarkness(null);
}
function setDarkness(newbody) {
  const darkClass = localStorage.getItem('fo-dark-mode') || '';
  const body = (newbody === null) ? document.body : newbody;
  const dark = document.getElementById('dark-mode').parentElement;
  const light = document.getElementById('light-mode').parentElement;
  if (darkClass.length > 0) {
    dark.classList.add('active');
    light.classList.remove('active');
  } else {
    dark.classList.remove('active');
    light.classList.add('active');
  }
  body.className = darkClass;
}
function copyToClipboard(string, id) {
  const obj = document.getElementById(id);
  obj.classList.remove('success-button');
  obj.classList.remove('failure-button');
  navigator.clipboard
    .writeText(string)
    .then(function() {
      obj.classList.add('success-button');
    }, function() {
      obj.classList.add('failure-button');
    });
}
function replaceBurger() {
  const menu = document.getElementById('hamburger');
  document.getElementById("hamlabel").innerHTML = menu.checked ? '<i class="fas fa-bars"></i>' : '<i class="fas fa-times"></i>';
  const searchResults = document.getElementById('search-results');
  const search = document.getElementById('search_');
  searchResults.innerHTML = '';
  search.value = '';
}
