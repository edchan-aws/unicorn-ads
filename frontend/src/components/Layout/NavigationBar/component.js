import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import Logo from '../../../images/logo.svg';

class NavigationBar extends Component {
	render(){
		return(
			<div className="header-container">
				<nav className="navbar navbar-default navbar-fixed-top">
					<div className="container">
					<div className="navbar-header">
				  		<button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
						<span className="sr-only">Toggle navigation</span>
						<span className="icon-bar"></span>
						<span className="icon-bar"></span>
						<span className="icon-bar"></span>
				  		</button>
				  		<Link to="/" className="navbar-brand"><img src={Logo}/><span>Unicorn Ads</span></Link>
					</div>
					<div className="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
						<ul className="nav navbar-nav navbar-right">
							<li><Link to="/ads" className="nav-links">Ads</Link></li>
				  		</ul>
					</div>
					</div>	
				</nav>
			</div>
		);
	}
}

export default NavigationBar;