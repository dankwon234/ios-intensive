var mongoose = require('mongoose');

var PlaceSchema = new mongoose.Schema({
	name: {type:String, trim:true, lowercase:true, default:''},
	address: {type:String, trim:true, lowercase:true, default:''},
	timestamp: {type:Date, default:Date.now}
});

PlaceSchema.methods.summary = function() {
	var summary = {
		'name':this.name,
		'address':this.address,
		'timestamp':this.timestamp,
		'id':this._id
	};
	
	return summary;
};


module.exports = mongoose.model('PlaceSchema', PlaceSchema);