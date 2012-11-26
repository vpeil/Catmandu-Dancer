// Full list of configuration options available here:
// https://github.com/hakimel/reveal.js#configuration
Reveal.initialize({

  // Display controls in the bottom right corner
  controls: false,

  // Display a presentation progress bar
  progress: true,

  // Push each slide change to the browser history
  history: false,

  // Enable keyboard shortcuts for navigation
  keyboard: true,

  // Enable the slide overview mode
  overview: true,

  // Vertical centering of slides
  center: true,

  // Loop the presentation
  loop: false,

  // Enable slide navigation via mouse wheel
  mouseWheel: false,

  // Apply a 3D roll to links on hover
  rollingLinks: false,

  // Transition style
  transition: Reveal.getQueryHash().transition || 'default',

  // Optional libraries used to extend on reveal.js
  dependencies: [

    // Cross-browser shim that fully implements classList - https://github.com/eligrey/classList.js/
    { src: 'reveal/lib/js/classList.js', condition: function() { return !document.body.classList; } },

    // Interpret Markdown in <section> elements
    // { src: 'plugin/markdown/showdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
    // { src: 'plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },

    // Syntax highlight for <code> elements
    { src: 'reveal/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } }

    // Zoom in and out with Alt+click
    // { src: 'plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },

    // Speaker notes
    // { src: 'plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } },

    // Remote control your reveal.js presentation using a touch device
    // { src: 'plugin/remotes/remotes.js', async: true, condition: function() { return !!document.body.classList; } }

  ]
});
