Config = require "./Config"
Resolution = require "./Resolution"

module?.exports = class Resolver
	/**
	* Registered dependencies
	*/
	_registry: {}


	/**
	* Created instances
	*/
	_instances: {}


	/**
	* Ongoing resolutions. Used to check of circular dependencies.
	*/
	_resolutionStack: {}


	/**
	* Internal, modified only for testing.
	*/
	_require: require


	/**
	* Set to a string to call this method on every newly created instance.
	*/
	initMethodName: null


	/**
	* Constructor
	*/
	->
		@_registry = {}
		@_instances = {}
		@_resolutionStack = {}


	/**
	* Get the dependency registration name (key) for an object
	*/
	_keyOf: (source) ->
		if typeof source == "function"
			then source
			else JSON.stringify(source)


	/**
	* Create a new instance of a given function.
	* New instance will have a property "_dr" that is set to this dependency resolver.
	* @param {Function} func - Function to create new instance of
	* @param {Array} args - Arguments to pass to the constructor
	*/
	_new: (func, args) ~>
		#Add this resolver as the first argument
		args = args ? []
		args.unshift this

		new (((a) -> func.apply(this, a)) <<< {prototype: func.prototype})(args)


	/**
	* Register a new dependency. There are several ways this function can be called:
	* 1. register(object) - registers an object/function using itself as the key
	* 2. register(key, object) - registers an object/function using "key" as the key
	* @param {String|Object|Function} key - String key of the object. Can be object itself.
	* @param {Object|Function} source - Object or function to register. Only needed if "key" is provided.
	* @return {Object} Dependency configuration object for further dependency customization.
	*/
	register: (name, source = name) ~>
		if not source?
			throw new Error "Can't register #{source} as a dependency."

		key = @_keyOf name

		if @_registry[key]?
			throw new Error "Dependency already registered: #{key}"

		return @_registry[key] = new Config source


	/**
	* Interprets arrays as register() calls, instead of dependencies.
	* Lets you use syntax like registerAll([dependency1, [key2, dependency2]]).
	* Will cause unpredictable results if used to register arrays as dependencies.
	* @param {Array} sources - Array containing dependency registrations.
	* @return {Array} An array of Configuration-s for each registered dep.
	*/
	registerAll: (sources) ~>
		results = []
		for source in sources
			if source.constructor == Array and source.length == 2
				result = @register source.0, source.1
			else
				result = @register source

			results .push result

		return results


	/**
	* Same as register().resolve.withRequire = true
	*/
	registerRequire: (key, source = key) ~>
		config = @register key, source

		config.resolve.withRequire = true


	/**
	* Resolve a dependency.
	* Source can be a string key or an object.
	* @param {Object} Dependency "class".
	* @returns {Object} Instance
	*/
	resolve: (source) ~>
		# Handle prepare()d resolution
		if source.constructor.displayName == Resolution.displayName
			[args, source] = [source.arguments, source.obj]

		key = @_keyOf source

		config = @_registry[key]

		if not config?
			throw new Error "Dependency not registered: #{key}"

		source = config.obj

		if config.instance.type == "none"
			return source

		if config.instance.type == "lifetime"
			instance = @_instances[key]

		if not instance?
			# Check for circular dependencies
			if @_resolutionStack[key]?
				throw new Error "Circular dependency detected! Tried to start resolution of
					 a dependency that's already in the process of resolving: #{key}."

			@_resolutionStack[key] = key

			if config.resolve.withRequire
				instance = @_require source
			else
				if typeof source != 'function'
					throw new Error "Cannot create an instance of non-function: #{key}"

				instance = @_new(source, args)

			if config.instance.type == "lifetime"
				@_instances[key] = instance

			config.beforeInit instance

			if @initMethodName? and typeof instance[@initMethodName] == 'function'
				instance[@initMethodName]!

		delete @_resolutionStack[key]
		return instance


	/**
	* Call resolve() on an array of sources and return an array of resolved objects.
	*/
	resolveAll: (...args) ~>
		sources = args
		if sources.length == 1 and sources.0.constructor == Array
			sources = args.0
		if sources.constructor != Array
			sources = [sources]

		results = []
		for source in sources
			results.push @resolve(source)

		return results


	/**
	* Prepare for a resolution.
	* Use to configure a resolution before executing it, for example, to add constructor parameters.
	* @params {Object|String} source - Dependency to prepare the resolution of
	* @return {Resolution} Resolution configuration object.
	*/
	prepare: (source) ~>
		new Resolution this, source


	/**
	* Get dependency configuration for a given source
	*/
	getConfigFor: (source) ~>
		return @_registry[@_keyOf source]

	/**
	* Create a new instance of DependencyResolver with the same configuration
	*/
	newLifetime: ~>
		newLife = new Resolver

		# Copy simple values
		for own name, prop of this when prop == null or typeof prop in ['string','number','undefined']
			newLife[name] = prop

		# Clone registry
		for key, val of @_registry
			newLife._registry[key] = {} <<< val

		return newLife