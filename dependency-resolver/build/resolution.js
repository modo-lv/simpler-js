(function(){
  var DependencyResolution, slice$ = [].slice;
  DependencyResolution = (function(){
    DependencyResolution.displayName = 'DependencyResolution';
    var prototype = DependencyResolution.prototype, constructor = DependencyResolution;
    /**
    * Owner DependencyResolver.
    */
    prototype.dr = null;
    /**
    * Object to resolve
    */
    prototype.obj = null;
    function DependencyResolution(dr, obj){
      this.dr = dr;
      this.obj = obj;
      this.createWith = bind$(this, 'createWith', prototype);
      this.resolve = bind$(this, 'resolve', prototype);
      this.addArguments = bind$(this, 'addArguments', prototype);
      this.arguments = [];
    }
    prototype.addArguments = function(){
      var args;
      args = slice$.call(arguments);
      this.arguments = this.arguments.concat(args);
      return this;
    };
    prototype.resolve = function(){
      return this.dr.resolve(this);
    };
    /**
    * Alias for addArguments(...).resolve()
    * @param {...} Arguments to pass to the constructor.
    */
    prototype.createWith = function(){
      return this.addArguments.apply(this, arguments).resolve();
    };
    return DependencyResolution;
  }());
  if (typeof module != 'undefined' && module !== null) {
    module.exports = DependencyResolution;
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
