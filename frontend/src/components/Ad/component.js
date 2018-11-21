import React, { Component } from 'react';
import Bike from '../../images/bike.jpg';

class Ad extends Component {
	render(){
		return(
			<div className="ad-container">
				<div className="container">
					<div className="row">
						<div className="col-md-3">
							<div className="ad">
								<div className="ad-image-container">
									<div className="ad-image" style={{backgroundImage: `url(${Bike})`}}></div>	
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		);
	}
}

export default Ad;
