// ==UserScript==
// @name         Open Links in Firefox
// @namespace    Smart User Scripts
// @version      0.1
// @description  Open links in Firefox when middle-clicked
// @match        *://*/*
// @grant        GM_openInTab
// @run-at       document-start
// @author       Tassilo Neubauer
// @updateURL    https://raw.githubusercontent.com/sonofhypnos/dotfiles/main/userscripts/open-in-firefox.user.js
// @downloadURL    https://raw.githubusercontent.com/sonofhypnos/dotfiles/main/userscripts/open-in-firefox.user.js
// ==/UserScript==

(function () {
  "use strict";

  // Firefox executable path - you may need to adjust this based on your system
  const firefoxPath = "firefox";

  document.addEventListener(
    "auxclick",
    function (e) {
      // Check if it's a middle mouse click (button 1)
      if (e.button === 1) {
        const target = e.target.closest("a");

        if (target && target.href) {
          e.preventDefault();
          e.stopPropagation();

          // opening via custom protocol handler
          window.location.href = "firefox://" + target.href;

          return false;
        }
      }
    },
    true,
  );

  // Add a hint to any links hovered (I should remove this after I got used to using this)
  document.addEventListener("mouseover", function (e) {
    const target = e.target.closest("a");
    if (target && target.href) {
      target.setAttribute("data-open-in-firefox", "true");
      target.title = target.title || "Middle-click to open in Firefox";
    }
  });
})();
