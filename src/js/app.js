'use strict';

define('App', [
  'domReady',
  'jquery',
  'excapes',
  'audio',
], (domReady, $, escapes, audiojs, audiojsInstance) => {

  return class App {

    constructor() {

      this.props = { 
        ansi: [ "art/CCCFIRE-V_FOR_VENDETTA.ANS" ],
        audio: null,
        element: 'body',
      };

      this.state = {
        index: (val) => (!val) ? Math.floor(Math.random() * this.props.ansi.length)
            		       : val % this.props.ansi.length
      };
    }

    bind(element) {
      if (element) this.props.element = document.queryselector(element);

      this.props['audio'] = audiojs.createAll();
      this.stateListener = this.render
    }

    render() {
      let self = this;

      domReady(() => {
         escapes(ansi[self.state['index']], () => { $(self.props['element']).appendTo('#art'); $('#art').fadeIn(150); });
      });
    }
  }
});
