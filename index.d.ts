import Roact = require("rbx-roact");

export as namespace RoactRouter;
export = RoactRouter;

type Dictionary<T> = {[index: string]: Roact.Element}

/** Props interface for extended component functionality.
 * To use this, extend the component's Props interface with this interface.
 * Allows the "Key" and "children" props to be used on a component.
 */
interface PropsBase {
    /**
     * The key of this element
     * In Roact, this would be the index of the Roact Element as a child of another element.
     * 
     * E.g. a key of "Bob" would be equivalent of  doing
     * ```lua
Roact.createElement(Parent, {...}, {
    Bob = Roact.createElement(ThisElement, {...})
})```
        */
    Key?: string
    /**
     * A table if child elements (by key) to be rendered in this component
     */
    [Roact.Children]?: Dictionary<Roact.Element>
}



// Router class utils



interface RouterProps extends PropsBase {
	/** Determines whether embedded routes should be cached
	 * 
	 * If true, route components will only mount once, and route pages will be frozen
	 * in their state while they are inactive. Instances on inactive routes are left
	 * alone with caching.
	 */
	caching?: boolean
	/** Describes the initial path for routing, as well as the starting URL.
	 * 
	 * The Default value is '/'
	 */
	root?: string
}
interface RouterState {
	/** The current path being routed to. */
	url: string
	/** Injected props concerning information about the current route */
	routerInjectedPropsCache: RoactRouter.RouteComponentProps
}



// Route class utils



interface RoduxConnection<S, P> {
	new (props: P): {};
}
type RouteParameters = {[index: string]: string}

type RouteClassComponent = Roact.RenderablePropsClass<RoactRouter.RouteComponentProps>
type RouteFunctionComponent = ((props: RoactRouter.RouteComponentProps) => Roact.Element)
type RouteConnectionComponent = RoduxConnection<any, RoactRouter.RouteComponentProps>

interface RouteProps_Base extends PropsBase {
    /** If true, the URL must be exactly matched (excluding sup-paths) */
    exact?: boolean
    /** The root path that the router will always resolveto */
    path: string
    /** The priority for which a switch should select this route */
    priority?: number
}
interface RouteProps_Component {
    /** The component to be mounted in this route */
    component: RoactRouter.RouteComponent
    render?: undefined
}
interface RouteProps_Render {
    /** Renders a single static component, which is Visible when the route is active. */
    render: (props: RoactRouter.RouteComponentProps) => Roact.Element
    component?: undefined
}
type RouteProps = RouteProps_Base & (RouteProps_Component | RouteProps_Render)

interface RouteState {
}



// Redirect component utils



interface RedirectProps extends PropsBase {
    /** The URL to redirect to when this component is rendered */
	to: string
	/** The amount of time to delay before redirecting */
	delay?: number
}
interface RedirectState extends PropsBase {
    /** True iff the redirect has been rendered and redirected the URL once */
    hasRedirected: boolean
}

/** Injected props for Route-wrapped or withRoute-wrapped components */
interface RouterInjectedProps {
	/** Information and helper functions related to the router */
	router: {
		/** Changes the display path for the router
		 * @params url The path to redirect to
		 * @params delay (optional) If provided, the router will spawn a thread that redirects after a certain period of time (if the redirect is not overridden)
		 */
		redirect: (url: string, delay?: number) => void
		/** The current URL path of the router */
		location: string
	}
	/** Information about how the route was matched */
	match: {
		/** The path pattern used to match */
		path: string
		/** The matched portion of the URL */
		url: string
		/** True iff the entire URL was matched (no trailing characters)*/
		isExact: boolean
		/** An object of string parameters passed in through the route*/
		params: RouteParameters
	}
}



// Unexposed util functions



/** Returns a table of props with component children injected, given the props of another element */
declare function InjectComponentChildren<T extends object>(elementProps: T, componentProps: PropsBase): T 

/** Adds the component to the context of all child components at a given symbol */
declare function BindComponentToContext(thisComponent: Roact.Component, symbol: Symbol): void

/** Retrieves an ancestor component from the context that was bound to some symbol */
declare function GetComponentFromContext<T extends Roact.Component = Roact.Component>(thisComponent: Roact.Component, symbol: Symbol): T | undefined

/** Renders the component as a portal that simply passes its children through the component's parent */
declare function PassThroughComponent(thisComponent: Roact.Component<any, any>, props: PropsBase): Roact.Element



// Exported namespace



declare namespace RoactRouter {



	// Router class component



	class Router extends Roact.Component<RouterProps, RouterState> {
		static getDefaultState: () => RouterState
		constructor(props: RouterProps)
		public render(): Roact.Element;

		/** Gets the router's current URL */
		GetURL(): string | undefined
		/** Redirects the router's URL
		 * @param url The URL to redirect to
		 */
		SetURL(url: string): void
		/** Returns true iff inactive routes are cached (determined through props) */
		GetIsCaching(): boolean
		/** Returns the object of injected router props */
		GetRouterProps(): Readonly<RouterInjectedProps>
	}



	// Switch class component



	class Switch extends Roact.Component<{}> {
		public render(): Roact.Element;
	}



	// Route class component



	/** A routable component must have props of type RouteComponentProps */
	type RouteComponentProps = RouterInjectedProps & PropsBase
	/** A routable component with props of type RouteComponentProps */
	type RouteComponent = RouteClassComponent | RouteFunctionComponent | RouteConnectionComponent
	class Route extends Roact.Component<RouteProps, RouteState> {
		// This *should* be in state, but the cache is pulled from each render update, meaning state cannot be modified.
		private routeComponentProps: RouteComponentProps
		private staticComponent?: Roact.Element | undefined
		private lastRenderedCache: Roact.Element
		private wasActive: boolean
		/** "Active" override parameter from a contextual switch */
		private overrideActive?: boolean | undefined
		/** "Active" override setter from a contextual Switch */
		private SetOverrideActive(isActive: boolean): void
		/** "Active" override getter from a contextual Switch */
		private GetOverrideActive(): boolean | undefined
		constructor(props: RouteProps)
		public render(): Roact.Element;
		public didMount(): void
		public willUnmount(): void

		// API functions

		/** Returns true iff a given url matches the route's path
		 * @param url the active URL to compare with the route's path
		 */
		public PathMatchesURL(url: string): boolean
		/** Returns the route parameters parsed from a matching URL
		 * @param url the active URL to compare with the route's path
		 */
		public GetRouteParams(url: string): RouteParameters
	}



	// Redirect class component



	/** Redirects the current router to another URL when rendered */
	class Redirect extends Roact.Component<RedirectProps, RedirectState> {
		static getDefaultState: () => RedirectState
		constructor(props: RedirectProps)
		render(): Roact.Element | undefined
	}

	const Test = "Test"



	// RouteCache class component



	/** Internally created component that caches inactive routes when nested inside of a Router that enables caching */
	class RouteCache extends Roact.Component<PropsBase> {
		constructor(props: PropsBase)
		/** Called when the route is no longer active, and the cache should be set invisible */
		Freeze(): void
		/** Called when the route is active again, and the cache should be set visible */
		Thaw(): void
		render(): Roact.Element | undefined
	}



	// Higher-order functional components



	/** Wraps a component to inject router props (of type "RouteComponentProps")
	 * @param wrappedComponent: The component to wrap. Must have props that extends RoactRouter.RouteComponentProps
	 */
	function withRouter(wrappedComponent: Roact.RenderablePropsClass<RouteComponentProps>): () => Roact.Element;



	// Util functions
	


	/** Returns the router that a component is nested in */
	function getRouter(component: Roact.Component): Router | undefined
	/** Returns the switch that a component is nested in */
    function getSwitch(component: Roact.Component): Switch | undefined



	// Core symbols



	/** Context marker that tells elements what Router they are nested in */
	type ContextRouter = Router
	/** Context marker that tells elements what Switch they are nested in */
	type ContextSwitch = Switch

	/** Context marker that tells elements what Router they are nested in */
    const ContextRouter: unique symbol
	/** Context marker that tells elements what Switch they are nested in */
    const ContextSwitch: unique symbol
}