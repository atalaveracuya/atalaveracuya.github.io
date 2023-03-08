var toggleSocialButton = document.getElementById('toggle-social');
var socialLinks = document.querySelector('.social');

toggleSocialButton.addEventListener('click', function() {
  socialLinks.classList.toggle('hidden');
});
