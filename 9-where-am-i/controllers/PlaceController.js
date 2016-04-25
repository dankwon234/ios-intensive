var Place = require('../models/Place');

module.exports = {

	get: function(params, completion){ // completion takes and 'err' and 'response' arg
		Place.find(params, function(err, places){
			if (err){
				completion(err, null);
				return;
			}

			completion(null, places);
			return;
		});
	},

	getById: function(id, completion){
		Place.findById(id, function(err, place){
			if (err){
				completion(err, null);
				return;
			}

			completion(null, place);
			return;
		});
	}

}