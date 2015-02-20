
class DependencyConfig
	(@obj) ->

	instance:
		/**
		* Instance creation lifetime scope.
		*/
		type: "lifetime"

	/**
	* Configure dependency to create a new instance on every resolve() request.
	*/
	instance-per-dependency: -> @instance.type = "dependency"; @

	/**
	* Configure dependency to create and re-use a single instance in the DependencyResolver object scope.
	*/
	instance-per-lifetime: -> @instance.type = "lifetime"; @

	/**
	* Do not create an instance. Meant for functions, objects already are instances so they default to lifetime scope.
	*/
	no-instance: -> @instance.type = "none"; @






if module? then module.exports = DependencyConfig