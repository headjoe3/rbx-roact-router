# rbx-roact-router
TypeScript-compatible routing components for Roact

## Requirements:
Roblox-TS: https://roblox-ts.github.io/

Roact (TypeScript): https://github.com/roblox-ts/rbx-roact

## Installation
Run the command `npm install rbx-roact-router` in your project workspace

## Documentation:
All of the module's exports are documented here: https://github.com/headjoe3/rbx-roact-router/wiki

## Example (tsx)
```jsx
import * as Roact from "rbx-roact"
import * as RoactRouter from "rbx-roact-router";

import { Router, Switch, Route, Redirect } from "rbx-roact-router";

const css_ambient = {
    BackgroundTransparency: 1,
    Size: new UDim2(1, 0, 1, 0),
}
const css_centered = {
    Position: new UDim2(0.5, 0, 0.5, 0),
    AnchorPoint: new Vector2(0.5, 0.5),
}
const css_solid_white = {
    BackgroundColor3: new Color3(0.85, 0.85, 0.85),
    BorderSizePixel: 0,
}
const css_black_text = {
    TextColor3: new Color3(0.15, 0.15, 0.15),
    Font: Enum.Font.SourceSans,
    FontSize: Enum.FontSize.Size24,
}
const css_black_text_italicized = {
    TextColor3: new Color3(0.15, 0.15, 0.15),
    Font: Enum.Font.SourceSansItalic,
    FontSize: Enum.FontSize.Size18,
}

class HomePage extends Roact.Component<RoactRouter.RouteComponentProps> {
    render() {
        return (
            <frame {...css_solid_white} {...css_centered} Size={new UDim2(0, 300, 0, 400)}>
                <uilistlayout FillDirection={Enum.FillDirection.Vertical} Padding={new UDim(0, 0)} SortOrder={Enum.SortOrder.LayoutOrder}/>
                <textlabel LayoutOrder={0} {...css_solid_white} {...css_black_text_italicized} Key="Label" Text={"Matched URL '" + this.props.match.url + "'"} Size={new UDim2(1, 0, 0.25, 0)}/>
                <textbutton LayoutOrder={1} {...css_solid_white} {...css_black_text} Key="Home button" Text={"Home"} Size={new UDim2(1, 0, 0.25, 0)}/>
                <textbutton LayoutOrder={2} {...css_solid_white} {...css_black_text} Key="Menu 1 button" Text={"Go to Menu 1"} Size={new UDim2(1, 0, 0.25, 0)} Event={{
                    MouseButton1Click: () => {
                        this.props.router.redirect("/menu1")
                        wait(2)
                        this.props.router.redirect("/nowhere")
                    }
                }}/>
                <textbutton LayoutOrder={3} {...css_solid_white} {...css_black_text} Key="Menu 2 button" Text={"Go to Menu 2"} Size={new UDim2(1, 0, 0.25, 0)} Event={{
                    MouseButton1Click: () => {
                        this.props.router.redirect("/menu2")
                    }
                }}/>
            </frame>
        )
    }
}

const MainGui = (
    <screengui>
        <Router caching={true}>
            <Switch>
                <Route priority = {0} Key="Home" path="/home" component={HomePage}/>
                <Route priority = {1} Key="Menu1" path="/menu1" render={(props) => (
                    <textlabel {...css_solid_white} {...css_centered} {...css_black_text} Text="Menu 1; redirecting in 2 seconds..." Size={new UDim2(0, 300, 0, 80)}/>
                )}/>
                <Route priority = {2} Key="Menu2" path="/menu2" render={(props) => (
                    <frame {...css_ambient}>
                        <textlabel {...css_solid_white} {...css_centered} {...css_black_text} Text="Menu 2; redirecting in 1 seconds..." Size={new UDim2(0, 300, 0, 80)}/>
                        <Redirect to="/nowhere" delay={1}/>
                    </frame>
                )}/>
                <Route priority = {100} Key="Default Redirect" path="/" render={(props) => (
                    <frame {...css_ambient}>
                        <textlabel {...css_solid_white} {...css_centered} {...css_black_text} Text="" Size={new UDim2(0, 300, 0, 400)}/>
                        <Redirect to="/home"/>
                    </frame>
                )}/>
            </Switch>
        </Router>
    </screengui>
)

Roact.mount(
    MainGui,
    (game.Players.LocalPlayer as Player).WaitForChild("PlayerGui") as PlayerGui,
    "MainGui"
)

export = () => {}
```
![TSX Example](https://i.imgur.com/ICfItZj.gif)
