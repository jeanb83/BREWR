// Listen to clicks on avatars
const avatarClick = () => {
  const avatars = Array.from(document.querySelectorAll('.avatars'));
  avatars.forEach(node => {
    node.addEventListener('click', (event) => {
      // Remove "active" class for every items in the list
      avatars.forEach(node => {
        node.classList.remove('active');
      });
      // Add "active" class for last clicked avatar
      event.currentTarget.classList.add('active');
      // Get dataset value of last clicked avatar
      const avatarFile = event.currentTarget.dataset.avatar;
      // Set hidden form field value to that value
      document.getElementById('avatar').value = avatarFile;
      console.log(avatarFile);
    });
    console.log("Loaded.");
  });
}

export { avatarClick };