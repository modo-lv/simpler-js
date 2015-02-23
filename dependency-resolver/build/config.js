(function(){
  var Config;
  if (typeof module != 'undefined' && module !== null) {
    module.exports = Config = (function(){
      Config.displayName = 'Config';
      var prototype = Config.prototype, constructor = Config;
      prototype.instance = {
        /**
        * Instance creation lifetime scope.
        */
        type: "lifetime"
      };
      prototype.resolve = {
        withRequire: false
      };
      function Config(obj){
        this.obj = obj;
        this.noInstance = bind$(this, 'noInstance', prototype);
        this.instancePerLifetime = bind$(this, 'instancePerLifetime', prototype);
        this.instancePerDependency = bind$(this, 'instancePerDependency', prototype);
        this.instance = {
          type: "lifetime"
        };
        this.resolve = {
          withRequire: false
        };
        this.beforeInit = function(){};
      }
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
      return Config;
    }());
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
