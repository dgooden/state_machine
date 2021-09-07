/// @function DTG_State()
/// @desc state structure for state machine
function DTG_State() constructor 
{
	_userData = {};
	_functions = {};
	
	///@function setUserData(data)
	///@desc saves data as userData	
	///@param {struct} data struct to be saved as userData
	static setUserData = function(data) 
	{
		_userData = {};
		var keys = variable_struct_get_names(data);
		for ( var i=0; i<array_length(keys); i++ ) {
			var key = keys[i];
			variable_struct_set(_userData,key,variable_struct_get(data,key));
		}
	}
	
	///@function getUserData
	///@desc returns userData struct
	///@return {struct}
	static getUserData = function()
	{
		return _userData;
	}
	
	///@function clearUserData
	///@desc clears the userData struct
	static clearUserData = function()
	{
		delete _userData;
		_userData = {};
	}
	
	///@function addCustom(functionName,callback)
	///@desc adds custom function
	///@param {string} functionName	Name of the function
	///@param {method} callback		Function code
	static addCustom = function(functionName,callback)
	{
		variable_struct_set(_functions,functionName,callback);
	}
	
	///@function customExists(functionName)
	///@desc returns whether or not the function exists	
	///@param {string} functionName Name of the function to check
	///@return {bool} 
	static getCustom = function(functionName)
	{
		return variable_struct_exists(_functions,functionName);
	}
	
	///@function removeCustom(functionName)
	///@desc removes a custom function from the state
	///@param {string} functionName Name of the function to remove
	static removeCustom = function(functionName)
	{
		if ( variable_struct_exists(_functions,functionName) ) {
			variable_struct_remove(_functions,functionName);
		}
	}
	
	///@funciton onCustom(functionName)
	///@desc executes the custom function
	///@param {string} functionName Name of the function
	static onCustom = function(functionName)
	{
		if ( variable_struct_exists(_functions,functionName) ) {
			var callback = variable_struct_get(_functions,functionName);
			callback(self);
		}
	}
	
	///@function onEnter()
	///@desc function called when state is first entered
	static onEnter = function() {}
	
	///@function onExit()
	///@desc function called when state is exiting
	static onExit  = function() {}
	
	///@function onDraw()
	///@desc function called during draw event
	static onDraw  = function() {}
	
	///@function onStep()
	///@desc function called during step event
	static onStep  = function() {}
}

///@function DTG_StateMachine()
///@desc state machine
function DTG_StateMachine() constructor 
{
	_curState = -1;
	_curName = "";
	_prevName = "";

	_states = {};
	
	_enterStateStartTime = 0;
	_framesSince = 0;

	///@function add(stateName,state)
	///@desc adds state
	///@param {string} stateName Name of the state to add
	///@param {struct} state	  DTG_State() struct to add
	static add = function(stateName, state) 
	{
		if ( ! variable_struct_exists(_states,stateName) ) {
			variable_struct_set(_states,stateName,state);
		}
	}
	
	///@function remove(stateName)
	///@desc removes the state
	///@param {string} stateName Name of the state to remove
	static remove = function (stateName) 
	{
		if ( variable_struct_exists(_states,stateName) ) {
			variable_struct_remove(_states,stateName);
		}
	}
	
	///@function update(stateName,state)
	///@desc updates the state
	///@param {string} stateName Name of the state to update
	///@param {struct} state	 DTG_State() struct to add
	static update = function(stateName,state) 
	{
		variable_struct_set(_states,stateName,state);
	}
	
	///@function getPreviousName()
	///@desc returns the name of the previous state
	///@return {string}
	static getPreviousName = function()
	{
		return _prevName;
	}
	
	///@function getName()
	///@desc returns the name of current state 
	///@return {string}
	static getName = function()
	{
		return _curName;
	}
	
	///@function get(stateName)
	///@desc returns the DTGGM_State() struct stored under stateName	
	///@param {string} stateName Name of the state
	///@return {struct}
	static get = function(stateName)
	{
		return variable_struct_get(_states,stateName);
	}
	
	///@function goto(stateName)
	///@desc goes to the new state specified by stateName
	///@param {string} stateName Name of the state
	static goto = function(stateName) {
		if ( stateName == _curName ) {
			return;
		}
			
		var newState = variable_struct_get(_states,stateName);
		if ( _curState != -1 ) {
			_curState.onExit(_curState);
			_prevName = _curName;
		}
		_curState = newState;
		_curName = stateName;

		_enterStateStartTime = get_timer();
		_framesSince = 0;		
		
		_curState.onEnter(_curState);
	}
	
	///@function getFrames()
	///@desc returns the number of frames that have passed since we entered this state
	///@return {real}
	static getFrames = function()
	{
		return _framesSince;	
	}
	
	///@function getTime(sec)
	///@desc returns the number of microseconds/seconds that have passed since we entered this state	
	///@param {bool} sec returns seconds instead of microseconds
	///@return {real}
	static getTime = function(sec)
	{
		var t =  (get_timer() - _enterStateStartTime);
		if ( sec ) {
			return (t/1000000);
		}
		return t
	}
	
	///@function getUserData()
	///@desc returns the user data for the current state
	///@return {struct}
	static getUserData = function()
	{
		return (_curState != -1) ? _curState.getUserData() : {};
	}
	
	///@function setUserData(data)
	///@desc sets the current state user data	
	///@param {struct} data The user data to set
	static setUserData = function(data)
	{
		if ( _curState != -1 ) {
			_curState.setUserData(data);
		}
	}
	
	///@function clearUserData()
	///@desc clears the current state user data
	static clearUserData = function(data)
	{
		if ( _curState != -1 ) {
			_curState.clearUserData();
		}
	}
	
	///@function empty()
	///@desc removes all states, leaving an empty state machine
	static empty = function()
	{
		delete _states;
		_states = {};
		_curState = -1;
		_curName = "";
		_prevName = "";
		_enterStateStartTime = 0;
		_framesSince = 0;
	}
	
	///@function step()
	///@desc call this every step function (if needed)
	///       required if you want to use framesSince
	static step = function()
	{
		if ( _curState != -1 ) {
			++_framesSince;
			_curState.onStep(_curState);
		}
	}
	
	///@function draw()
	///@desc call this every draw function (if needed)
	static draw = function()
	{
		if ( _curState != -1 ) {
			_curState.onDraw(_curState);
		}
	}
	
	///@function custom(functionName)
	///@desc call this to execute custom a function
	///@param {string} functionName Name of the custom function to call
	static custom = function(functionName)
	{
		if ( _curState != -1 && _curState.getCustom(functionName) ) {
			_curState.onCustom(functionName);
		}
	}
}
