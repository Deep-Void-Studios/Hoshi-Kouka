local module = {
	Muted = false; -- Set to true to mute all sounds
	AnimateIn = true; 
	AnimationDirection = "Left"; -- Right or Left. Left for right side of screen, vice versa

	Height = UDim.new(0.65, 0);

	InTime = 0.5; -- Defaults
	Lifetime = 5; -- Defaults
	OutTime = 2; -- Defaults

	Padding = 25; -- Pixels	
};

return module
