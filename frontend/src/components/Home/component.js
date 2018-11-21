import React, { Component } from 'react';
import Ads from '../Ads';

class Home extends Component {
	render(){
		return(
			<div className="home-container">
				<div className="container">
					<Ads />
				</div>	
			</div>
		);
	}
}

export default Home;