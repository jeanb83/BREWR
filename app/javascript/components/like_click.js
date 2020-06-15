// Listen to clicks on fontawesome face
const likeClick = () => {
  const likeButtons = Array.from(document.querySelectorAll('.bw_event-likes'));
  likeButtons.forEach(node => {
    node.addEventListener('click', (event) => {
      // Get dataset value of last clicked fontawesome face
      const likeValue = event.currentTarget.dataset.tastelike;
      const taste = event.currentTarget.dataset.taste;
      // Remove "active" class for every items in the list
      const sameLineButtons = Array.from(document.querySelectorAll(`.bw_event-likes.${taste}`));
      sameLineButtons.forEach(node => {
        node.classList.remove('active');
      });
      // Add "active" class for last clicked fontawesome face
      event.currentTarget.classList.add('active');
      // Set hidden form field value to that value
      document.getElementById(`${taste}_like`).value = likeValue;
      console.log(`${taste} => ${likeValue}`);
    });
  });
}

export { likeClick };