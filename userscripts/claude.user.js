// ==UserScript==
// @name         Claude.ai Shortcuts
// @namespace    Smart User Scripts
// @version      0.2
// @description  Open Claude.ai new chat when pressing Ctrl+Shift+O
// @match        https://claude.ai/*
// @grant        none
// @author      Smart Manoj
// @updateURL   https://raw.githubusercontent.com/sonofhypnos/dotfiles/main/userscripts/claude.user.js
// @downloadURL   https://raw.githubusercontent.com/sonofhypnos/dotfiles/main/userscripts/claude.user.js
// ==/UserScript==

(function () {
  "use strict";

  document.addEventListener("keydown", function (e) {
    if (e.ctrlKey && e.shiftKey && e.key === "O") {
      e.preventDefault();
      window.open("https://claude.ai/chat/new", "_self");
    }
  });
})();
