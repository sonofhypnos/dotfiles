// ==UserScript==
// @name         Maps Shortcuts
// @namespace    Smart User Scripts
// @version      0.2
// @description  Shortcut for maps
// @match        https://maps.google.com/*
// @match        https://www.google.com/maps/*
// @grant        none
// @author      Tassilo Neubauer
// @updateURL   https://raw.githubusercontent.com/sonofhypnos/dotfiles/main/userscripts/maps.user.js
// ==/UserScript==


(function() {
    'use strict';

    document.addEventListener('keydown', function(e) {
        if (e.key === 'f' && !isInputFocused()) {
            e.preventDefault();
            const searchInput = document.querySelector('#searchboxinput');
            if (searchInput) {
                searchInput.focus();
                searchInput.select();
            }
        }
    });

    function isInputFocused() {
        const activeElement = document.activeElement;
        return activeElement.tagName === 'INPUT' ||
               activeElement.tagName === 'TEXTAREA' ||
               activeElement.isContentEditable;
    }
})();
