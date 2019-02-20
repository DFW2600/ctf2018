'use strict';

// ============================================================================
// main.js - entrypoint
// version: v1.0.0
// ============================================================================

// defaults paths
requirejs.config({
    paths: {
	'domReady': 'vendor/domReady',
        'jquery': 'vendor/jquery.min',
        'escapes': 'vendor/escapes.min',
        'audio': 'vendor/audio.min',
	'snowflakes': 'vendor/snowflakes.min',
	'App': 'app',
    }, 
    shim: {
	'App': { exports: 'App' },
        'audio': { exports: 'audiojs' },
        'escapes': { deps: ['jquery'] },
    }
});

requirejs(['App'], (App) => {

  // Render App
  const app = new App();

});
