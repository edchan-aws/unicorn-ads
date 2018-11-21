import React from 'react';
import {
	BrowserRouter as Router,
	Route,
	Switch
} from 'react-router-dom';

import App from './components/App';
import Layout from './components/Layout';
import Home from './components/Home';
import Ads from './components/Ads';
import NotFound from './components/NotFound';

const AppRouter = () => (
	<Router>
		<App>
			<Layout>
				<Switch>
					<Route exact path="/ads" component={Ads} />
					<Route exact path="/" component={Home} />
					<Route component={NotFound} />
				</Switch>
			</Layout>
		</App>
	</Router>
);

export default AppRouter;