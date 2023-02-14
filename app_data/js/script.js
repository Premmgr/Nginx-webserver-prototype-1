const title = document.getElementById("title");
const javascripttest = document.getElementById("javascript-test");
const colortest = document.getElementById("color-test");
const timeDisplay = document.createElement("h2");
timeDisplay.style.fontSize = "50px";
timeDisplay.style.fontWeight = "bold";
timeDisplay.style.color = "white";

document.body.appendChild(timeDisplay);

setInterval(() => {
  const currentTime = new Date().toLocaleTimeString();
  timeDisplay.innerHTML = currentTime;
}, 1000);

javascripttest.addEventListener("click", () => {
  title.innerHTML = "Test Passed!";
  title.style.color = "white";
});

colortest.addEventListener("click", () => {
  document.body.classList.toggle("cltest");
});
