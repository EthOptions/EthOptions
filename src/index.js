import React from 'react';
import ReactDOM from 'react-dom';
// import Web3wrapper from './Web3wrapper';
import App from './App';
import './index.css';

import WebFontLoader from 'webfontloader';

WebFontLoader.load({
  google: {
    families: ['Roboto:300,400,500,700', 'Material Icons'],
  },
});


ReactDOM.render(<App />, document.getElementById('root'));
