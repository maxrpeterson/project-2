var logRegPanel = document.querySelector("#log-reg");
var loginPanel = document.querySelector("#user-actions div.login");
var registerPanel = document.querySelector("#user-actions div.register");
var notLoggedIn = document.querySelector(".not-logged-in")
var loginButton = document.querySelector("h5.login");
var registerButton = document.querySelector("h5.register");

function hide(targetNode) {
	targetNode.classList.add("no-display")
};

function show(targetNode) {
	targetNode.classList.remove("no-display")
};

notLoggedIn.addEventListener("click", function() {
	show(logRegPanel);
	hide(notLoggedIn);
});

registerButton.addEventListener("click", function() {
	show(registerPanel);
	registerButton.classList.add("active");
	loginButton.classList.remove("active");
	hide(loginPanel);
})

loginButton.addEventListener("click", function() {
	hide(registerPanel);
	registerButton.classList.remove("active");
	loginButton.classList.add("active");
	show(loginPanel);
})