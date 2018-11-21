import React, { Component } from 'react';
import NavigationBar from './NavigationBar';

class Layout extends Component {
	render(){
		return(
			<div className="layout-container">
				<NavigationBar />
				<div className="content-container">
					{ this.props.children }
				</div>
				<div className="footer-container">
					Footer	
				</div>
			</div>
		);
	}
}

export default Layout;