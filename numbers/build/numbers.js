(function(){
  var numbers;
  numbers = {
    /**
    * Round a number to a given number of decimal places.
    * @param {Number} number
    * @param {Number} precision
    * @returns {Number}
    */
    round: function(number, precision){
      precision == null && (precision = 0);
      return numbers.withPrecision(Math.round, number, precision);
    }
    /**
    * Same as Math.floor, but with optional precision
    */,
    floor: function(number, precision){
      precision == null && (precision = 0);
      return numbers.withPrecision(Math.floor, number, precision);
    }
    /**
    * Same as Math.ceil(), but with optional precision
    */,
    ceil: function(number, precision){
      precision == null && (precision = 0);
      return numbers.withPrecision(Math.ceil, number, precision);
    }
    /**
     * Perform a (usually rounding) function with a given precision
     * @param {Function} func
     * @param {Number} number
     * @param {Number} precision
     * @returns {Number}
     */,
    withPrecision: function(func, number, precision){
      var power;
      precision == null && (precision = 0);
      power = Math.pow(10, precision);
      return func(number * power) / power;
    }
    /**
     * Returns a random number between min & max, both inclusive, with optional precision.
     * @param {Number} min
     * @param {Number} max
     * @param {Number} precision
     * @returns {Number}
     */,
    random: function(min, max, precision){
      var pow, add, rand;
      precision == null && (precision = 0);
      pow = Math.pow(10, precision);
      add = 1 / pow;
      rand = Math.random() * (max - min + add);
      return numbers.floor(rand + min, precision);
    }
  };
  if (typeof window != 'undefined' && window !== null) {
    window.numbers = numbers;
  }
  if (typeof module != 'undefined' && module !== null) {
    module.exports = numbers;
  }
}).call(this);
