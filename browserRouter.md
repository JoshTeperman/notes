## Rendering a component

### `<Route component={Component}>`

A React component will be rendered only when the `location` matches, will be rendered with route props (location, history, match)

Creates a new React element from the Component passed in using `React.createElement`, so when you provide an inline function to the component prop you will create a new component every render, resulting in the existing component unmounting and a new component mounting every render, rather than just updating the existing component.

### `<Route render>`

Convenient inline rendering without the remounting above. Pass in a function to be called when the `location` matches.

### `<Router children> function`

Works like `render` except it renders whether the location matches or not. Receives the same route props, except when a location doesn't match the `match` prop is `null`.

Useful pattern:

```
<Route
  children={({ match, ...rest }) => (
    {/* Animate will always render, so you can use lifecycles
        to animate its child in and out */}
    <Animate>
      {match && <Something {...rest}/>}
    </Animate>
  )}
/>
```

### `<Route><Component /></Route>

You can render a component as a child of the `<Route />` component. But it doesn't appear to allow props to be passed down.

## Route props

The first 3 render methods have access to `match`, `location`, and `history`, usually only available through the browser API on the `window` object. Possibly the reason the first 3 can pass down props but not the fourth is that the first three render using functions: `React.createElement()`, `render(() => {})`, and the passing down a callback to the `children` prop that can render components.

```
// All route props (match, location and history) are available to User
function User(props) {
  return <h1>Hello {props.match.params.username}!</h1>;
}

ReactDOM.render(
  <Router>
    <Route path="/user/:username" component={User} />
  </Router>,
  node
);
```

## this.props.history
Note: different to Browser History, which is a DOM specific implementation.

In React Router, `history` is a lightweight wrapper built over the browser's `History` and `Location` APIs, and, along with `match`, are made available directly through props without having to access the browser `Window` object.

The browser `History` API, and therefore the `history` object in React Router, allows you to manipulate browser session history, (manage the history stack) using Javascript, navigate, and persist state between sessions.

- `history.length` => number of entries in the history stack
- `history.action` => the current action (`PUSH`, `POP`, `REPLACE`)
- `history.push` => pushes a new url to props.history
- `history.location` =>
  - `pathname` - (string) The path of the URL
  - `search` - (string) The URL query string
  - `hash` - (string) The URL hash fragment
  - `state` - (object) location-specific state that was provided to e.g. push(path, state) when this location was pushed onto the stack. Only available in browser and memory history.

## this.props.location

`location` is an object that can be found on the `history` object. It can represent where the app is now, where you want it to go, where it was.

Since `history.location` is mutable, the recommended way to access it is through the render props of `<Route />`, not from `history.location`.

Since `this.props.location` is never mutated, it can be used in the lifecycle hooks to determine when navigation happens, or passed it in as a variable for navigation.

Provide it to `Link to`, `Redirect to`, `history.push`, `history.replace` as an object and you give access to location state:

```
// eg:

const location = {
  pathName:"/dashboard",
  state: {someState: 'something'}
}

<Link to={location} />
<Redirect to={location}>

history.push(location)
history.replace(location)
```

## this.props.match

- `match.params` (object)
- `match.isExact` (bool) => true if the entire url was matched
- `match.path` (string) => the path pattern used to match. Used to build nested `<Route />s`.
- `match.url` (string) => the matched portion of the URL. Used to build nested `<Link />s`.

Especially useful for dynamic links (using `/:id`), as you can grab the id with `const { id } = match.params` and use it in to fetch data for a particular Model.

## With Ruby on Rails routes.rb

1) In the browser, hit the root url that is the entry-point to your single-page app
2) Javascript files registered in that pack are bundled and loaded into the index.html file, including Routing files and all of the React components.
3) The Routing system tells the browser what components to render by matching the url path (anything after the root path)
4) The components render, and any subsequent requests for data are sent
5) Any subsequent internal navigation will use the Routing system, as long as the root path is the same root entry to the single-page-app

### EXAMPLE:

```
// app/config/routes.rb

resources :challenges
root to: challenges#index
```

```
// app/controllers/challenges_controller.rb

class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.all
  end
end
```

```
// app/views/challenges/index.html.erb

<%= javascript_pack_tag 'index' %>
```

```
// app/javascript/packs/index.js

import React, { useQuery } from 'react';
import ReactDom from 'react-dom';
import { BrowserRouter, Route, Switch } from 'react-router-dom';

const App = () => (
  <BrowserRouter>
    <App>
      <Switch>
        <Route path="/challenges" component={Challenges} />
        <Route exact path="/" component={Home}/>
      </Switch>
    </App>
  </BrowserRouter>
);

const Challenges = () => {
  const {loading, error, data} = useQuery(GET_CHALLENGES);

  return <div> // Challenge data // </div>;
}

const Home = () => (
  <div>Home Page</div>
);

ReactDOM.render(<App>, document.querySelector('#root'));
```

For the above example, the entry point to the single-page app is found at `localhost:3000/` or `localhost:3000/challenges`, both of which route to the `#index` method in the `challenges_controller`.

The `challenges#index` method corresponds with a Rails view `index.html.erb`, which contains a `javascript_pack_tag`, telling Webpacker to bundle the files in the `index` pack, which can be found at `app/javascript/packs/index.js`.

The `index.js` file contains the `ReactDOM.render` function, which converts all of our React javascript components into Markdown, and inserts them into the DOM at `<div id="root" />` in our `application.html.erb` file.

This entry point is crucial in understanding what to expect when using React Router to navigate within our App, and interacting with the browser `History` and `Location` APIs.

Understand that for any request thatt is hitting the entry point to the React application, there are two types of routing going on:

First Rails server will attempt to route the request url, and given a mathing route will action the corresponding controller method. Once the response has been served, React Router will attempt to match the same url to predefined paths, which then tell the client what to render to the DOM.

For example, navigating to the url `"http://localhost:3000/"` in the browser will trigger the following request in Rails server:

```
Started GET "/" for ::1 at 2019-11-23 13:03:38 +1100
Processing by ChallengesController#index as HTML
  Rendering challenges/index.html.erb within layouts/application
  Rendered challenges/index.html.erb within layouts/application (2.5ms)
Completed 200 OK in 15ms (Views: 13.7ms | ActiveRecord: 0.0ms)
```

We can see a `GET` request to the path `"/"`, which is processed by the `#index` method in the `challenges_controller` as expected. Rails then renders its views, the layout file `application.html.erb` and the view that corresponds with `challenges#index`, our `challenges/index.html.erb` file. The response sends a `200` "OK" status. Finally, React Router should match the path `"/"` to the corresponding `<Route />`, resulting in the `<Home />` component being rendered in the browser.

Contrast this with what happens when we navigate to `"http://localhost:3000/challenges"`:

```
Started GET "/challenges" for ::1 at 2019-11-23 13:03:48 +1100
Processing by ChallengesController#index as HTML
  Rendering challenges/index.html.erb within layouts/application
  Rendered challenges/index.html.erb within layouts/application (2.1ms)
Completed 200 OK in 15ms (Views: 14.4ms | ActiveRecord: 0.0ms)

Started POST "/graphql" for ::1 at 2019-11-23 13:03:48 +1100
Processing by GraphqlController#execute as */*
  Parameters: {"operationName"=>nil, "variables"=>{}, "query"=>"{\n  challenges {\n    id\n    name\n    description\n    language\n    __typename\n  }\n}\n", "graphql"=>{"operationName"=>nil, "variables"=>{}, "query"=>"{\n  challenges {\n    id\n    name\n    description\n    language\n    __typename\n  }\n}\n"}}
  Challenge Load (0.2ms)  SELECT "challenges".* FROM "challenges"
  ↳ app/controllers/graphql_controller.rb:9
Completed 200 OK in 3ms (Views: 0.2ms | ActiveRecord: 0.2ms)
```

We can see that hitting `localhost/challenges` results in a `GET` request to `"/challenges"`. Even though the url is different to our first example, we are pointing at the same controller and method in our `routes.rb` file, therefore our request is processed by `challenges#index`, which results in a render of the same Rails view `challenges.index.html.erb` and we get another `200` OK status response.

What you can is that this time a second request has been logged.

Just like the first example, React Router has taken the original request url and successfully matched that to the `<Route />` with the prop `path="/challenges"`, resulting in the  render of the `<Challenges />` component. This in turn triggers a `useQuery` GraphQL query, which is a second POST request to the `graphql_controller`, an SQL query for data from the `challenges` table, and a response with that data.

Both requests hit the same Rails route, the same controller, method, and view, but resulted in completely differrent behaviour based on the routing of React Router.


Note that removing the `root to: 'challenges#index'` from `routes.rb` and navigating to `/` will not hit the React Router path `/` because Rails no longer routes the request to `challenges#index`. Instead you'll get the default Rails home screen:

```
Started GET "/" for ::1 at 2019-11-23 14:33:59 +1100
Processing by Rails::WelcomeController#index as HTML
  Rendering /Users/Josh/.asdf/installs/ruby/2.6.0/lib/ruby/gems/2.6.0/gems/railties-5.2.3/lib/rails/templates/rails/welcome/index.html.erb
  Rendered /Users/Josh/.asdf/installs/ruby/2.6.0/lib/ruby/gems/2.6.0/gems/railties-5.2.3/lib/rails/templates/rails/welcome/index.html.erb (1.9ms)
Completed 200 OK in 6ms (Views: 3.1ms | ActiveRecord: 0.0ms)
```


### Nested routes with a single controller method

To navigate to `http://localhost:3000/challenges/new`, Rails is going to try to look for a `new` method in the `challenges_controller`, which doesn't exist. We could create a new method and a view for this route, but that won't allow us to use our entry point to our single page app. What we actually want is for Rails to still recognise that `/challenges` is our entry-point,
`/challenges/new` => looks for `challenges#new`, which doesn't exist. Do I need a `new.html.erb` and provide another entry point to the React app?

`get "/*other", to: 'challenges#index', default: {other: 'challenges'}`
... this will force any call to `/` to use `challenges#index`, yet allow different url strings.

## Hooks -> `useHistory()`

Gives you access to the `history` object that you can use to navigate

```
import { useHistory } from 'react-router-dom';

const HomeButton = () => {
  let history = useHistory()

  const handleClick = () => {
    history.push("/home");
  }

  return (
    <button onClick={handleClick}>Go Home</button>
  );
}
```

## Hooks -> `useParams()`

```
import { useParams, BrowserRouter as Router, Switch, Route } from 'react-router-dom';
const BlogPost = () => {
  let { slug } = useParams();
  return <div>Now showing post {slug}</div>;
}

ReactDOM.render(
  <Router>
    <Switch>
      <Route path="/blog/:slug" component={BlogPost}>
    </Switch>
  </Router>,
  node
);
```

## `withRouter()`

Higher Order Component that connects a component to the Router and passes `location`, `history`, and `match` down as props.

```
import { withRouter } from 'react-router-dom';

const Component = (props) => {
  const { history, location, match } = props

  return (
    <div>Some Component</div>
  );
}

export default withRouter(Component);
```
