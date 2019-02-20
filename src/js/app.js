define('App', [
  'domReady',
  'jquery',
  'audio',
  'escapes',
], (domReady, $, audiojs, audiojsInstance) => {


  class App {

    constructor(props) {

      this.props = props || { 
        ansi: [ "art/CCCFIRE-V_FOR_VENDETTA.ANS" ],
        audio: null,
        element: 'body',
      };

      this.state = {
        index: (val) => (!val) ? Math.floor(Math.random() * this.props.ansi.length)
            		       : val % this.props.ansi.length
      };

      this.bind();
      domReady(() => this.render());

    }

    bind(element) {
      this.props.element = document.querySelector((element) ? element : "#art");
      this.props['audio'] = audiojs.createAll();
      //this.stateListener = this.render
    }

    render() {

      escapes(this.props.ansi[this.state['index']()], function() {
	$(this).appendTo('#art');
	$('#art').fadeIn(150);
      })

    }

  }

  return App;
});
