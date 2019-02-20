'use strict';

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
        'audio': { exports: 'audiojs' },
        'escapes': { deps: ['jquery'] },
        'app': { deps: ['domReady', 'escapes', 'audio'] },
    }
});

requirejs(['app'], (App) => {

  // Render App
  const app = new App;
        app.bind();

});
