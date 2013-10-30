SensorModel = require('models/temperature-model')

module.exports = TemperatureCollection = Backbone.Collection.extend({
	url: 'http://127.0.0.1:4000/sensor/',
	model : SensorModel
});
