```
npm i apollo-boost        // Package containing everything you need to set up Apollo Client
npm i @apollo/react-hooks // React hooks based view layer integration
npm i graphql             // Also parses your GraphQL queries
```

### Create a client with `ApolloClient` constructor

You will need an end point for your graphql server, which defaults to `/graphql`

```
import { ApolloClient } from 'apollo-boost';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { HttpLink } from 'apollo-link-http';

const client = new ApolloClient({ 
  // required
  cache: new InMemoryCache();,
  link: new HttpLink(),

  // optional
  name: 'react-web-client',
  version: '1.3',
  defaultOptions: {},
})
```

`import ApolloClient from 'apollo-boost';` imports the full version of ApolloClient, which doesn't support specifying link / cache. You can `import { ApolloClient } from 'apollo-boost';`, which is the Apollo Boost version of ApolloClient and doesn't require link/cache. 

Alternatively, you can just import the full client with `import ApolloClient from 'apollo-client';`.

`cache`: Apollo Client uses an Apollo Cache instance to handle its caching strategy. The recommended cache is apollo-cache-inmemory, which exports an { InMemoryCache }.

`link`: Apollo Client uses an Apollo Link instance to serve as its network layer. The vast majority of clients use HTTP and should provide an instance of HttpLink from the apollo-link-http package.

```
// example link:

import { createHttpLink } from 'apollo-link-http';

createHttpLink({
  uri: '/defaults to /graphql',
  headers,
  credentials,
})
```

### Query with plain Javascript

Assuming same file as your ApolloClient...

```
import { gql } from 'apollo-boost'; // or import gql from 'graphql-tag';

client
  .query({
    query: gql`
      {
        something {
          somethingElse
        }
      }
    `
  })
  .then(() => console.log(result));
```

### Connect to React with `ApolloProvider`

To connect Apollo to React, use the `ApolloProvider` component exported from `@apollo/react-hooks`. 

`ApolloProvider` works similarly to `Context.Provider` from React in that it wraps your React App and places the client on the context, allowing you to access it from anywhere in your component tree.

`ApolloProvider` should be put somehwere high in your App, above anywhere you may want to make a Graphql Query. 

#### Pattern 1:
```
// App.js 

import React from 'react';
import { render } from 'react-dom';

import { ApolloProvider } from '@apollo/react-hooks';

const App = () => (
  <ApolloProvider client={client}>
    <div>
      <h2>My first Apollo App</h2>
    </div>
  </ApolloProvider>
);

render(<App />, document.getElementById('root'))
```

#### Pattern 2:
```
// javascript/packs/clients/graphql.js

import ApolloClient from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-memory';
import { HttpLink } from 'apollo-link-http';

const client = newApolloClient({ 
  link: new HttpLink(),
  cache: new InMemoryCahce(),  
})

export default client;


// javascript/packs/containers/graphql/Provider.js

import React from 'react';
import { ApolloProvider } from '@apollo/react-hooks';

import client from '../../clients/graphql';

const Provider = ({ children }) => (
  <ApolloProvider>
    {children}
  </ApolloProvider>
)

export default Provider;


// App.js

import React from 'react';
import GraphQlProvider from './containers/graphql/Provider';

const App = () => (
  <GraphQlProvider>
    <div>Hello World!</div>
  </GraphQlProvider>
)

export default App;
```

### Query with React and `useQuery`

Wrap you query in a `gql` function and pass it to `useQuery` hook.

When your component renders the `useQuery` hook will run, returning a `result` object containing `loading`, `error`, and `data` properties. 

Apollo client tracks `loading` and `error` properties for you. 

Once your query response comes back it's value will be added to the data propery and cached to speed up subsequent queries.

```
import React from 'react';
import { gql } from 'apollo-boost';
import { useQuery } from '@apollo/react-hooks';

const GET_DOG_PHOTO = gql`
  query Dog($breed: String!) {
    dog(breed: $breed) {
      id
      displayImage
    }
  }
`;

const DogPhoto = ({ breed }) => {
  const { loading, error, data } = useQuery(GET_DOG_PHOTO, {
    variables: { breed },
  });

  if (loading) return <Loader />
  if (error) return <ErrorScreen />

  return <p>{...data}</p>
} 
```

### Polling and Refetching

https://www.apollographql.com/docs/react/data/queries/#updating-cached-query-results


### useQuery hook API

The `useQuery` hook returns a result object with the following properties:

- data
- loading // boolean
- error 
- variables
- networkStatus
- refetch // allows you to refetch the query and pass in new variables
- fetchMore // enables pagination
- startPolling // a function that sets up a polling interval
- stopPolling
- subscribeToMore // sets up a subscription
- updateQuery // update the query's result in the cache outside the context of a fetch, mutation or subscription
- client // your ApolloClient instance
- called // boolean


### Update your data with `useMutation` hook
https://www.apollographql.com/docs/react/data/mutations/

### Pagination with `fetchMore`
https://www.apollographql.com/docs/react/data/pagination/

