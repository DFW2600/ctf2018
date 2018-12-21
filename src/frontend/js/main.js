// ============================================================================
// main.js - entrypoint
// ============================================================================

// defaults paths
requirejs.config({
    paths: {
	'jquery': 'jquery.min',
        'escapes': 'escapes.min',
        'audio': 'audio.min',
        'snowflakes': 'https://unpkg.com/magic-snowflakes/dist/snowflakes.min.js"
    }, 
    shim: {
	'escapes': { deps: ['jquery'] },
	'audio': { exports: 'audiojs' },
    }
});

require(["jquery", "audio", "escapes", 'snowflakes'], function($, audiojs, audiojsInstance, Snowflakes) {

  // Constants
  var ansi = [ "/art/xmassanta.ans", "/art/xmastree.ans"];

  // Helpers()
  function setArt(index) {

    if (!index)
      index = Math.floor(Math.random() * ansi.length);

    escapes(ansi[index], function () {
      $(this).appendTo('#art');
      $("#art").fadeIn(150);
    });

  }

  // Render()
  $(document).ready(function() {
    var snow = new Snowflakes({ color: '#f3f3fc' });
    setArt();
    audiojs.createAll();
  });

});
