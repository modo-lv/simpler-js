DependencyConfig = require "./DependencyConfig"
DependencyResolution = require "./DependencyResolution"

module?.exports = class DependencyResolver
	_registry: {}

	_instances: {}


	->
		/**
		* Registered dependencies
		*/
		@_registry = {}

		/**
		* Created instances
		*/
		@_instances = {}


	/**
	* Set to a string to call this method on every newly created instance.
	*/
	initMethodName: null


	/**
	* Get the dependency registration name (key) for an object
	*/
	_keyFor: (target) ->
		if typeof target == "function"
			then target
			else JSON.stringify(target)

	/**
	* Create a new instance of a given function.
	* New instance will have a property "_dr" that is set to this dependency resolver.
	* @param {Function} func - Function to create new instance of
	* @param {Array} args - Arguments to pass to the constructor
	*/
	_new: (func, args) ~>
		new (((a) -> func.apply(this, a)) <<< {prototype: func.prototype})(args)
			.._dr = this


	/**
	* Register a new dependency. There are several ways this function can be called:
	* 1. register(object) - registers an object/function using itself as the key
	* 2. register(key, object) - registers an object/function using "key" as the key
	* @param {String|Object|Function} key - String key of the object. Can be object itself.
	* @param {Object|Function} Object or function to register. Only needed if "key" is provided.
	* @return {Object} Dependency configuration object for further dependency customization.
	*/
	register: (key, target) ~>
		if not target?
			target = key
			key = null

		if not target?
			throw new Error "Can't register #{target} as a dependency."

		key = @_keyFor key ? target

		if @_registry[key]?
			throw new Error "Dependency already registered: #{key}"

		return @_registry[key] = new DependencyConfig target


	/**
	* Interprets arrays as register() calls, instead of dependencies.
	* Lets you use syntax like registerAll([dependency1, [key2, dependency2]]).
	* Will cause unpredictable results if used to register arrays as dependencies.
	* @param {Array} targets - Array containing dependency registrations.
	* @return {Array} An array of DependencyConfiguration-s for each registered dep.
	*/
	registerAll: (targets) ~>
		results = []
		for target in targets
			if target.constructor == Array and target.length == 2
				result = @register target.0, target.1
			else
				result = @register target

			results .push result

		return results


	/**
	* Resolve a dependency.
	* Target can be a string key or an object.
	* @param {Object} Dependency "class".
	* @returns {Object} Instance
	*/
	resolve: (target) ~>
		# Handle prepare()d resolution
		if target.constructor.displayName == DependencyResolution.displayName
			[args, target] = [target.arguments, target.obj]

		key = @_keyFor target
		config = @_registry[key]

		if not config?
			throw new Error "Dependency not registered: #{key}"

		target = config.obj

		if config.instance.type == "none"
			return target

		if config.instance.type == "lifetime"
			instance = @_instances[key]

		if not instance?
			if typeof target != 'function'
				throw new Error "Cannot create an instance of non-function: #{key}"
			instance = @_new(target, args)
			if config.instance.type == "lifetime"
				@_instances[key] = instance

		if @initMethodName? and typeof instance[@initMethodName] == 'function'
			instance[@initMethodName]!

		return instance



	/**
	* Call resolve() on an array of targets and return an array of resolved objects.
	*/
	resolveAll: (targets) ~>
		results = []
		for target in targets
			results.push @resolve(target)

		return results


	/**
	* Prepare for a resolution.
	* Use to configure a resolution before executing it, for example, to add constructor parameters.
	* @params {Object|String} target - Target dependency to prepare the resolution of
	* @return {DependencyResolution} Resolution configuration object.
	*/
	prepare: (target) ~>
		new DependencyResolution this, target

	/**
	* Create a new instance of DependencyResolver with the same configuration
	*/
	newLifetime: ~>
		newLife = new DependencyResolver
		for key, val of @_registry
			newLife._registry[key] = {} <<< val
		return newLife