DependencyConfig = require "./DependencyConfig"
DependencyResolution = require "./DependencyResolution"

class DependencyResolver
	->
		@_registry = {}

	/**
	* Registered dependencies
	*/
	_registry: {}

	/**
	* Created instances
	*/
	_instances: {}

	/**
	* Get the dependency registration name (key) for an object
	*/
	_keyFor: (target) ~>
		if typeof target == "function"
			then target.constructor || target
			else JSON.stringify(target)

	/**
	* Create a new instance of a given function
	* @param {Function} func - Function to create new instance of
	* @param {Array} args - Arguments to pass to the constructor
	*/
	_new: (func, args) ->
		new (((a) -> func.apply(this, a)) <<< {prototype: func.prototype})(args)

	/**
	* Register a new dependency.
	* @param {Object|Function} Object or function to register.
	* @return {Object} Dependency configuration object for further dependency customization.
	*/
	register: (target) ~>
		key = @_keyFor target

		if @_registry[key]?
			throw new Error "Dependency already registered: #{key}"

		return @_registry[key] = new DependencyConfig target


	/**
	* Resolve a dependency
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

		if config.instance.type == "none"
			return target

		if config.instance.type == "lifetime"
			instance = @_registry[key]

		if not instance?
			instance = @_new(target, args)

		return instance

	prepare: (target) ~>
		new DependencyResolution this, target

	/**
	* Create a new instance of DependencyResolver with the same configuration
	*/
	newLifetime: ~>
		newLife = new DependencyResolver
		for key, val of _registry
			newLife._registry[key] = ^^_registry[key]


if module? then module.exports = DependencyResolver