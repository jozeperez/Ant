-- ** load all libraries being used ** --
local ui = require( "libraries/ui" );
local imgs = require( "libraries/images" );

-- ** Set app data (as globals) ** --
app_globals = {
	-- hide status bar of phone --
	hide_status_bar = display.setStatusBar( display.HiddenStatusBar ),
	
	-- set game background --
	background = display.newImage( imgs.fetchImagePath( "bg_meadow.png" ) ),
	
	-- calculate center of the x axis
	centerX = display.contentWidth / 2,
	
	-- keep count of total balls --
	total_balls = 0,
	
	-- limit of balls --
	max_balls = 20,
	
	-- ** universal gravity ** --
	gravity = { x = 1.5, y = 20 },
	
	-- ** determine if high res ** --
	is_high_res = imgs.isHighRes()
};

-- ** cache math library functions ** --
local rand = math.random;

-- ** add and start physics, set gravity (explained in part 1) ** --
local physics = require("physics");
physics.start();
-- physics.pause();
physics.setGravity( app_globals.gravity.x, app_globals.gravity.y );

-- ** create tennis ball ** --
local function createBall( ball_count )

	-- ** create new instance of tennis ball ** --
	local tennis_ball = display.newImage( imgs.fetchImagePath( "bg_tennis_ball.png" ) );
	
	-- ** set tennis ball id ** --
	tennis_ball.tb_id = "tb_" .. ( ball_count + 1 );
	
	-- ** initiate bounces of this ball ** --
	tennis_ball.bounces = 0;  -- set to zero --
	
	-- ** position tennis ball ** --
	tennis_ball.x = rand( 15, 305 );  -- set x axis --
	tennis_ball.y = -15;  -- set y axis --
	tennis_ball.rotation = 1;
	
	-- ** add physics to ball ** --
	physics.addBody( tennis_ball, { bounce = 0.8, density = 1.0 } );
	
	-- ** incremente count of balls ** --
	app_globals.total_balls = app_globals.total_balls + 1;
	
	-- ** return new object ** --
	return tennis_ball;
	
end

-- ** spawn tennis ball(s) ** --
local function spawnBall()
	
	-- ** check to see if max balls created ** --
	if( app_globals.total_balls < app_globals.max_balls ) then
		-- ** fetch new ball ** --
		timer.performWithDelay( 100,
			function()
				-- ** create ball ** --
				createBall( app_globals.total_balls );
			end,
		1 );
	end
end

-- ** ball bounce event handler ** --
local function ballBounce( e )
	
	-- ** save bouncing ball ** --
	local ball = e.object2;
	
	-- ** detect first bounce ** --
	if ( e.phase == "began" and ball.bounces == 0 ) then
		spawnBall();
		--native.showAlert( "Corona", "test" );
	end
	
	-- ** track every bounce ** --
	ball.bounces = ball.bounces + 1;
	
	-- ** return ** --
	return;
end

-- ** add ball bounce listener ** --
Runtime:addEventListener( "collision", ballBounce );

-- ** create floor (for physics) ** --
floor = display.newRect( 0, ( app_globals.is_high_res and 860 or 430 ), ( app_globals.is_high_res and 640 or 320 ), ( app_globals.is_high_res and 100 or 50 ) );
floor.alpha = 0;
	
-- adds phyiscs properties to the newly added floor
physics.addBody( floor, "static", { bounce = 0.4, density = 1.0 } );

-- ** add ant to stage (global access) ** --
ant_player = display.newImage( imgs.fetchImagePath( "bg_ant.png" ) );

	-- ** set in middle of screen (on the floor) ** --
	if( app_globals.is_high_res ) then
		ant_player.x = 320;
		ant_player.y = 810;
	else
		ant_player.x = 160;
		ant_player.y = 405;
	end
	
	-- ** add physics to ant ** --
	physics.addBody( ant_player, "kinematic" );
	
-- ** game controls ** --
	
	-- ** interpret touch control ** --
	local distance_traveled = ( app_globals.is_high_res and 60 or 30 );
	
	local moveLeft = function( e )
	
		-- ** move 30px to the left ** --
		transition.to( ant_player, { time = 100, x= ( ant_player.x - distance_traveled ) } );
	
	end
	
	local moveRight = function( e )
	
		-- ** move 30/60px to the right ** --
		transition.to( ant_player, { time = 100, x= ( ant_player.x + distance_traveled ) } );
	
	end
	
	-- ** create controls ** --
	local left_btn = ui.newButton{
		default = imgs.fetchImagePath( "btn_left.png" ),
		-- over = "btn_whoA.png",
		onRelease = moveLeft
	};
	
	local right_btn = ui.newButton{
		default = imgs.fetchImagePath( "btn_right.png" ),
		-- over = "btn_whoA.png",
		onRelease = moveRight
	};
		
		-- ** position controls ** --
		if( app_globals.is_high_res ) then
			left_btn.x = 52;	
			left_btn.y = 910;
			right_btn.x = 590;
			right_btn.y = 910;
		else
			left_btn.x = 26;	
			left_btn.y = 455;
			right_btn.x = 295;
			right_btn.y = 455;
		end
	
-- ** start balls ** --
spawnBall();

--native.showAlert( "test", display.stageWidth .. " == " .. display.stageHeight );