// ==UserScript==
// @name         LessWrong Bookmarks Fix
// @namespace    Smart User Scripts
// @version      0.1
// @description  Fix "Load More" functionality for bookmarks page on LessWrong
// @match        https://www.lesswrong.com/bookmarks*
// @grant        none
// @author       Tassilo Neubauer
// @updateURL   https://raw.githubusercontent.com/sonofhypnos/dotfiles/main/userscripts/lw.user.js
// ==/UserScript==

(function() {
    'use strict';

    // Function to fetch all bookmarks using GraphQL
    async function fetchAllBookmarks(limit = 500) {
        // GraphQL endpoint for LessWrong
        const endpoint = 'https://www.lesswrong.com/graphql';

        // Create GraphQL query to get all bookmarked posts
        const query = `{
            posts(input: {
                terms: {
                    view: "myBookmarkedPosts"
                    limit: ${limit}
                }
            }) {
                results {
                    _id
                    title
                    slug
                    url
                    pageUrl
                    postedAt
                    baseScore
                    voteCount
                    commentsCount
                    user {
                        username
                        slug
                    }
                }
                totalCount
            }
        }`;

        // Make the request
        const response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ query }),
            credentials: 'include' // Important for authentication
        });

        const data = await response.json();
        return data.data.posts.results;
    }

    // Function to replace the existing bookmarks with all bookmarks
    async function replaceBookmarksSection() {
        // Wait for the bookmarks section to load
        await waitForElement('.BookmarksList-root');

        // Get all bookmarks via GraphQL
        const allBookmarks = await fetchAllBookmarks();
        console.log(`Fetched ${allBookmarks.length} bookmarks`);

        // Find the container for bookmarks
        const bookmarksContainer = document.querySelector('.BookmarksList-root');
        if (!bookmarksContainer) return;

        // Save the existing "Empty" message if present
        const emptyMessage = bookmarksContainer.querySelector('div[class*="empty"]');

        // Clear the existing bookmarks (except the empty message if it exists)
        Array.from(bookmarksContainer.children).forEach(child => {
            if (child !== emptyMessage) {
                child.remove();
            }
        });

        // If no bookmarks, we don't need to do anything
        if (allBookmarks.length === 0) return;

        // Remove empty message if it exists and we have bookmarks
        if (emptyMessage) emptyMessage.remove();

        // Create a new container for our posts
        const postsContainer = document.createElement('div');
        bookmarksContainer.appendChild(postsContainer);

        // For each bookmark, clone and modify an existing post item template
        // This is complex because we need to create React-compatible DOM elements
        // The simpler approach is to just reload the page after replacing the Load More button

        // Add a message showing the total count
        const countMessage = document.createElement('div');
        countMessage.textContent = `Showing all ${allBookmarks.length} bookmarks`;
        countMessage.style.marginBottom = '20px';
        countMessage.style.fontStyle = 'italic';
        bookmarksContainer.insertBefore(countMessage, bookmarksContainer.firstChild);
    }

    // Helper function to wait for an element to appear in the DOM
    function waitForElement(selector) {
        return new Promise(resolve => {
            if (document.querySelector(selector)) {
                return resolve(document.querySelector(selector));
            }

            const observer = new MutationObserver(mutations => {
                if (document.querySelector(selector)) {
                    observer.disconnect();
                    resolve(document.querySelector(selector));
                }
            });

            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
        });
    }

    // Simpler approach: Replace the Load More button with our own button
    async function enhanceLoadMoreButton() {
        const loadMoreButton = await waitForElement('button.LoadMore-loadMoreButton');
        if (!loadMoreButton) return;

        // Create a new button
        const newButton = document.createElement('button');
        newButton.textContent = "Load ALL Bookmarks";
        newButton.style.marginTop = '20px';
        newButton.style.padding = '8px 16px';
        newButton.style.backgroundColor = '#5f9bc0';
        newButton.style.color = 'white';
        newButton.style.border = 'none';
        newButton.style.borderRadius = '4px';
        newButton.style.cursor = 'pointer';

        // Add the button to the page
        loadMoreButton.parentNode.insertBefore(newButton, loadMoreButton.nextSibling);

        // Add click event
        newButton.addEventListener('click', async () => {
            newButton.textContent = "Loading all bookmarks...";
            newButton.disabled = true;

            const totalBookmarks = document.querySelector('.BookmarksList-root')
                ?.closest('[data-reactroot]')
                ?.__reactInternalInstance$
                ?._currentElement
                ?._owner
                ?._instance
                ?.props
                ?.currentUser
                ?.bookmarkedPostsMetadata
                ?.length || 0;

            // Keep clicking load more until all are loaded
            const loadMore = async () => {
                const visiblePosts = document.querySelectorAll('.PostsItem-root').length;
                if (loadMoreButton && !loadMoreButton.disabled && visiblePosts < totalBookmarks) {
                    loadMoreButton.click();
                    // Wait for loading to complete
                    await new Promise(r => setTimeout(r, 1000));
                    await loadMore();
                } else {
                    newButton.textContent = `✓ Loaded all ${visiblePosts} bookmarks`;
                    newButton.style.backgroundColor = '#4CAF50';
                }
            };

            await loadMore();
        });
    }

    // Run on page load
    window.addEventListener('load', () => {
        enhanceLoadMoreButton();
    });
})();
