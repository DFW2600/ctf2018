// ============================================================================
// main.js - entrypoint
// ============================================================================

// defaults paths
requirejs.config({
    paths: {
	'jquery': 'jquery.min',
        'escapes': 'escapes.min',
        'audio': 'audio.min',
    }, 
    shim: {
	'escapes': { deps: ['jquery'] },
	'audio': { exports: 'audiojs' },
    }
});

require(["jquery", "audio", "escapes"], function($, audiojs, audiojsInstance) {

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
    setArt();
    audiojs.createAll();
  });

});
