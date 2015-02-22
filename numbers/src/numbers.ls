numbers =
	/**
	* Round a number to a given number of decimal places.
	* @param {Number} number
	* @param {Number} precision
	* @returns {Number}
	*/
	round: (number, precision = 0) ->
		numbers.withPrecision(Math.round, number, precision);

	/**
	* Same as Math.floor, but with optional precision
	*/
	floor: (number, precision = 0) ->
		numbers.withPrecision Math.floor, number, precision


	/**
	* Same as Math.ceil(), but with optional precision
	*/
	ceil: (number, precision = 0) ->
		numbers.withPrecision Math.ceil, number, precision


	/**
	 * Perform a (usually rounding) function with a given precision
	 * @param {Function} func
	 * @param {Number} number
	 * @param {Number} precision
	 * @returns {Number}
	 */
	withPrecision : (func, number, precision = 0) ->
		power = 10 ** precision
		func(number * power) / power


	/**
	 * Returns a random number between min & max, both inclusive, with optional precision.
	 * @param {Number} min
	 * @param {Number} max
	 * @param {Number} precision
	 * @returns {Number}
	 */
	random: (min, max, precision = 0) ->
		pow = 10 ** precision
		add = 1 / pow

		rand = Math.random! * (max - min + add)

		numbers.floor rand + min, precision


window?.numbers = numbers
module?.exports = numbers