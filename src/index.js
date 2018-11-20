import React from 'react';
import ReactDOM from 'react-dom';
import App from './App.jsx';
import './styles/app.sass';

ReactDOM.render(
	<App />,
	document.getElementById('app')
);

module.hot.accept();
