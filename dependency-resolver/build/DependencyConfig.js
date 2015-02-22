// Generated by LiveScript 1.3.1
(function(){
  var DependencyConfig;
  if (typeof module != 'undefined' && module !== null) {
    module.exports = DependencyConfig = (function(){
      DependencyConfig.displayName = 'DependencyConfig';
      var prototype = DependencyConfig.prototype, constructor = DependencyConfig;
      function DependencyConfig(obj){
        this.obj = obj;
        this.noInstance = bind$(this, 'noInstance', prototype);
        this.instancePerLifetime = bind$(this, 'instancePerLifetime', prototype);
        this.instancePerDependency = bind$(this, 'instancePerDependency', prototype);
        this.instance = {
          type: "lifetime"
        };
        this.beforeInit = function(){};
      }
      prototype.instance = {
        /**
        * Instance creation lifetime scope.
        */
        type: "lifetime"
      };
      /**
      * Configure dependency to create a new instance on every resolve() request.
      */
      prototype.instancePerDependency = function(){
        this.instance.type = "dependency";
        return this;
      };
      /**
      * Configure dependency to create and re-use a single instance in the DependencyResolver object scope.
      */
      prototype.instancePerLifetime = function(){
        this.instance.type = "lifetime";
        return this;
      };
      /**
      * Do not create an instance. Meant for functions, objects already are instances so they default to lifetime scope.
      */
      prototype.noInstance = function(){
        this.instance.type = "none";
        return this;
      };
      /**
      * Define a method to call before calling init function
      	*/
      prototype.beforeInit = function(){};
      return DependencyConfig;
    }());
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
