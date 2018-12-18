requirejs.config({
    paths: {
	'jquery': 'jquery.min',
        'escapes': 'escapes.min',
        'audio': 'audio.min'
    }, 
    shim: {
	'escapes': { deps: ['jquery'] },
	'audio': { exports: 'audiojs' },
    }
});

var libs = [
    "jquery",
    "audio",
    "escapes"
];

var ansi = [ "/art/xmassanta.ans", "/art/xmastree.ans"];

function randomArt() {
    return ansi[Math.floor(Math.random() * ansi.length)];
}

function setArt() {
    escapes(randomArt(), function () {
      $(this).appendTo('#art');
      $("#art").fadeIn(250);
    });
}

// Render()

require(libs, function($, audiojs, audiojsInstance, ) {

  $(document).ready(function() {
    setArt();
  });

  audiojs.createAll();

});
