// CountDown for votes

const counter = setInterval(timer, 1000); //1000 will  run it every 1 second

function timer() {
  count = count - 1;
  if (count <= 0) {
    clearInterval(counter);
    //counter ended, do something here
    return;
  }

  document.getElementById("timer").innerHTML = count + " secs"; // watch for spelling//Do code for showing the number of seconds here
}

export { countdown };