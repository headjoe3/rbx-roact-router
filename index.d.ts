import Roact = require("rbx-roact");

export as namespace RoactRouter;
export = RoactRouter;

declare namespace RoactRouter {
	class Router extends Roact.Component<{}> {
		public render(): Roact.Element;
	}

	const withRouter: (props: any) => Roact.Element;
}