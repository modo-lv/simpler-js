// Generated by LiveScript 1.3.1
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
    return DependencyResolution;
  }());
  if (typeof module != 'undefined' && module !== null) {
    module.exports = DependencyResolution;
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);