var Question = require('../models/Question');

module.exports = {

	get: function(params, completion){ // completion takes and 'err' and 'response' arg
		Question.find(params, function(err, questions){
			if (err){
				completion(err, null);
				return;
			}


			completion(null, questions);
			return;
		});
	},

	getById: function(id, completion){
		Question.findById(id, function(err, question){
			if (err){
				completion(err, null);
				return;
			}


			completion(null, profile);
			return;
		});
	},

	post: function(params, completion){
		// console.log('CREATE QUESTION: '+JSON.stringify(params));
		var options = params['options[]']
		if (options != null){ // What the fuck Apple???
			params['options'] = params['options[]']
		}

		Question.create(params, function(err, question){
			if (err){
				completion(err, null);
				return;
			}

			completion(null, question);
			return;
		});
	}


}