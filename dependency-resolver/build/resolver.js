(function(){
  var Config, Resolution, Resolver, slice$ = [].slice;
  Config = require("./Config");
  Resolution = require("./Resolution");
  if (typeof module != 'undefined' && module !== null) {
    module.exports = Resolver = (function(){
      Resolver.displayName = 'Resolver';
      var prototype = Resolver.prototype, constructor = Resolver;
      /**
      * Registered dependencies
      */
      prototype._registry = {};
      /**
      * Created instances
      */
      prototype._instances = {};
      /**
      * Ongoing resolutions. Used to check of circular dependencies.
      */
      prototype._resolutionStack = {};
      /**
      * Internal, modified only for testing.
      */
      prototype._require = require;
      /**
      * Set to a string to call this method on every newly created instance.
      */
      prototype.initMethodName = null;
      /**
      * Constructor
      */;
      function Resolver(){
        this.newLifetime = bind$(this, 'newLifetime', prototype);
        this.getConfigFor = bind$(this, 'getConfigFor', prototype);
        this.prepare = bind$(this, 'prepare', prototype);
        this.resolveAll = bind$(this, 'resolveAll', prototype);
        this.resolve = bind$(this, 'resolve', prototype);
        this.registerRequire = bind$(this, 'registerRequire', prototype);
        this.registerAll = bind$(this, 'registerAll', prototype);
        this.register = bind$(this, 'register', prototype);
        this._new = bind$(this, '_new', prototype);
        this._registry = {};
        this._instances = {};
        this._resolutionStack = {};
      }
      /**
      * Get the dependency registration name (key) for an object
      */
      prototype._keyOf = function(source){
        if (typeof source === "function") {
          return source;
        } else {
          return JSON.stringify(source);
        }
      };
      /**
      * Create a new instance of a given function.
      * New instance will have a property "_dr" that is set to this dependency resolver.
      * @param {Function} func - Function to create new instance of
      * @param {Array} args - Arguments to pass to the constructor
      */
      prototype._new = function(func, args){
        var ref$;
        args = args != null
          ? args
          : [];
        args.unshift(this);
        return new (ref$ = function(a){
          return func.apply(this, a);
        }, ref$.prototype = func.prototype, ref$)(args);
      };
      /**
      * Register a new dependency. There are several ways this function can be called:
      * 1. register(object) - registers an object/function using itself as the key
      * 2. register(key, object) - registers an object/function using "key" as the key
      * @param {String|Object|Function} key - String key of the object. Can be object itself.
      * @param {Object|Function} source - Object or function to register. Only needed if "key" is provided.
      * @return {Object} Dependency configuration object for further dependency customization.
      */
      prototype.register = function(name, source){
        var key;
        source == null && (source = name);
        if (source == null) {
          throw new Error("Can't register " + source + " as a dependency.");
        }
        key = this._keyOf(name);
        if (this._registry[key] != null) {
          throw new Error("Dependency already registered: " + key);
        }
        return this._registry[key] = new Config(source);
      };
      /**
      * Interprets arrays as register() calls, instead of dependencies.
      * Lets you use syntax like registerAll([dependency1, [key2, dependency2]]).
      * Will cause unpredictable results if used to register arrays as dependencies.
      * @param {Array} sources - Array containing dependency registrations.
      * @return {Array} An array of Configuration-s for each registered dep.
      */
      prototype.registerAll = function(sources){
        var results, i$, len$, source, result;
        results = [];
        for (i$ = 0, len$ = sources.length; i$ < len$; ++i$) {
          source = sources[i$];
          if (source.constructor === Array && source.length === 2) {
            result = this.register(source[0], source[1]);
          } else {
            result = this.register(source);
          }
          results.push(result);
        }
        return results;
      };
      /**
      * Same as register().resolve.withRequire = true
      */
      prototype.registerRequire = function(key, source){
        var config;
        source == null && (source = key);
        config = this.register(key, source);
        return config.resolve.withRequire = true;
      };
      /**
      * Resolve a dependency.
      * Source can be a string key or an object.
      * @param {Object} Dependency "class".
      * @returns {Object} Instance
      */
      prototype.resolve = function(source){
        var ref$, args, key, config, instance;
        if (source.constructor.displayName === Resolution.displayName) {
          ref$ = [source.arguments, source.obj], args = ref$[0], source = ref$[1];
        }
        key = this._keyOf(source);
        config = this._registry[key];
        if (config == null) {
          throw new Error("Dependency not registered: " + key);
        }
        source = config.obj;
        if (config.instance.type === "none") {
          return source;
        }
        if (config.instance.type === "lifetime") {
          instance = this._instances[key];
        }
        if (instance == null) {
          if (this._resolutionStack[key] != null) {
            throw new Error("Circular dependency detected! Tried to start resolution ofa dependency that's already in the process of resolving: " + key + ".");
          }
          this._resolutionStack[key] = key;
          if (config.resolve.withRequire) {
            instance = this._require(source);
          } else {
            if (typeof source !== 'function') {
              throw new Error("Cannot create an instance of non-function: " + key);
            }
            instance = this._new(source, args);
          }
          if (config.instance.type === "lifetime") {
            this._instances[key] = instance;
          }
          config.beforeInit(instance);
          if (this.initMethodName != null && typeof instance[this.initMethodName] === 'function') {
            instance[this.initMethodName]();
          }
        }
        delete this._resolutionStack[key];
        return instance;
      };
      /**
      * Call resolve() on an array of sources and return an array of resolved objects.
      */
      prototype.resolveAll = function(){
        var args, sources, results, i$, len$, source;
        args = slice$.call(arguments);
        sources = args;
        if (sources.length === 1 && sources[0].constructor === Array) {
          sources = args[0];
        }
        if (sources.constructor !== Array) {
          sources = [sources];
        }
        results = [];
        for (i$ = 0, len$ = sources.length; i$ < len$; ++i$) {
          source = sources[i$];
          results.push(this.resolve(source));
        }
        return results;
      };
      /**
      * Prepare for a resolution.
      * Use to configure a resolution before executing it, for example, to add constructor parameters.
      * @params {Object|String} source - Dependency to prepare the resolution of
      * @return {Resolution} Resolution configuration object.
      */
      prototype.prepare = function(source){
        return new Resolution(this, source);
      };
      /**
      * Get dependency configuration for a given source
      */
      prototype.getConfigFor = function(source){
        return this._registry[this._keyOf(source)];
      };
      /**
      * Create a new instance of DependencyResolver with the same configuration
      */
      prototype.newLifetime = function(){
        var newLife, name, prop, ref$, key, val, own$ = {}.hasOwnProperty;
        newLife = new Resolver;
        for (name in this) if (own$.call(this, name)) {
          prop = this[name];
          if (prop === null || ((ref$ = typeof prop) === 'string' || ref$ === 'number' || ref$ === 'undefined')) {
            newLife[name] = prop;
          }
        }
        for (key in ref$ = this._registry) {
          val = ref$[key];
          newLife._registry[key] = import$({}, val);
        }
        return newLife;
      };
      return Resolver;
    }());
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
