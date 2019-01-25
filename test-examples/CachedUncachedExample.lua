--[[ Place this code in a LocalScript ]]
local Roact = require(game.ReplicatedStorage:FindFirstChild("rbx-roact", true).roact.lib)
local RoactRouter = require(game.ReplicatedStorage:FindFirstChild("rbx-roact-router", true).router.lib)

local MyComponent1 = Roact.Component:extend("MyComponent")
function MyComponent1:render()
	print("Rendering component 1 in context", RoactRouter.getRouter(self))
	return Roact.createElement(
		"TextButton",
		{
			Size = UDim2.new(0, 100, 0, 40),
			Position = self.props.rightSide and UDim2.new(0.5, 3, 0.5, -3) or UDim2.new(0.5, -3, 0.5, -3),
			AnchorPoint = self.props.rightSide and Vector2.new(0, 1) or Vector2.new(1, 1),
			Text = self.props.rightSide and "Route to / (uncached)" or "Route to /Test (cached)",
			TextWrapped = true,
			[Roact.Event.MouseButton1Click] = function()
				self.props.router.redirect("/Test")
			end,
		}
	)
end
function MyComponent1:didMount() 
	print(self.props.rightSide and "Mounted component 1 (uncached)" or "Mounted component 1 (cached)")
end

local MyComponent2 = Roact.Component:extend("MyComponent")
function MyComponent2:render()
	print("Rendering component 2 in context", RoactRouter.getRouter(self))
	return Roact.createElement(
		"TextButton",
		{
			Size = UDim2.new(0, 100, 0, 40),
			Position = self.props.rightSide and UDim2.new(0.5, 3, 0.5, 3) or UDim2.new(0.5, -3, 0.5, 3),
			AnchorPoint = self.props.rightSide and Vector2.new(0, 0) or Vector2.new(1, 0),
			Text = self.props.rightSide and "Route to / (uncached)" or "Route to / (cached)",
			TextWrapped = true,
			[Roact.Event.MouseButton1Click] = function()
				self.props.router.redirect("/")
			end,
		}
	)
end
function MyComponent2:didMount() 
	print(self.props.rightSide and "Mounted component 2 (uncached)" or "Mounted component 2 (cached)")
end

Roact.mount(
	Roact.createElement(
		"ScreenGui", {
			ResetOnSpawn = false
		},
		{
			-- Cached component router
			Roact.createElement(
				RoactRouter.Router,
				{
					caching = true,
				},
				{
					Roact.createElement(
						RoactRouter.Switch,
						{},
						{
							["Route /"] = Roact.createElement(
								RoactRouter.Route,
								{
									path="/",
									exact=true,
									component=MyComponent1,
									priority=0,
								}
							),
							["Route /Test"] = Roact.createElement(
								RoactRouter.Route,
								{
									path="/Test",
									component=MyComponent2,
									priority=1,
								}
							)
						}
					)
				}
			),
			-- Uncached render router
			Roact.createElement(
				RoactRouter.Router,
				{
					caching = false,
				},
				{
					Roact.createElement(
						RoactRouter.Switch,
						{},
						{
							["Route /"] = Roact.createElement(
								RoactRouter.Route,
								{
									path="/",
									exact=true,
									render=function(routeProps)
										local props = {rightSide = true}
										for k,v in pairs(routeProps) do
											props[k] = v
										end
										return Roact.createElement(
											MyComponent1,
											props
										)
									end,
									priority=0,
								}
							),
							["Route /Test"] = Roact.createElement(
								RoactRouter.Route,
								{
									path="/Test",
									render=function(routeProps)
										local props = {rightSide = true}
										for k,v in pairs(routeProps) do
											props[k] = v
										end
										return Roact.createElement(
											MyComponent2,
											props
										)
									end,
									priority=1,
								}
							)
						}
					)
				}
			)
		}
	),
	game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	"RoactRouterTestMain"
)