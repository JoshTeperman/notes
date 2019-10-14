### SCRIPTS:
```
"scripts": {
  "build": "gatsby build",
  "develop": "cross-env GATSBY_GRAPHQL_IDE=playground gatsby develop",
  "format": "prettier --write src/**/*.{js,jsx}",
  "start": "npm run develop",
  "serve": "gatsby serve",
  "test": "echo \"Write tests! -> https://gatsby.dev/unit-testing\""
},
```

uses Reach Router under the hood:

```
import { Link } from 'gatsby'
<Link to='/'>&larr; back to home</Link>
```

### COMPONENTS

this page will be available at localhost:8000/about

```
// this is an unnamed component

import React from 'react';

export default () => (
  <>
    <h1>About Me</h1>
    <p>This is my personal website</p>
  </>
);
```

## Styles

### Emotion

- @emotion/core
  - emotion core
  - emtion css prop
- @emotion/styled
- gatsby-plugin-emotion
  - allows gatsby to build the plugin


```
// gatsby-config.js/

module.exports = {
  plugins: ['gatsby-plugin-emotion'],
};
```

```
// components/layout.js

import React from 'react';
import { Global, css } from '@emotion/core';

const Layout = ({ children }) => (
  <>
    <Global styles={css``} />
  </>
)
```
```
// index.js

import Layout from '../components/Layout';

export default () => (
  <Layout>
    <p>Hello</p>
  </Layout>
);
```

## GraphQl

```
import { graphql, useStaticQuery } from 'gatsby';

const useSiteMetadata = () => {
  console.log('sitemetadata query function');
  const data = useStaticQuery(graphql`
    query {
      site {
        siteMetadata {
          title
          description
        }
      }
    }
  `);
  return data.site.siteMetadata;
};

export default useSiteMetadata;
```

## MDX

`npm i npm i gatsby-plugin-mdx @mdx-js/mdx @mdx-js/react`

Make sure MDX files are loaded using default layout:

```
// gatsby-config.js

plugins: [
    {
      resolve: 'gatsby-plugin-mdx',
      options: {
        defaultLayouts: {
          default: require.resolve('./src/components/layout.js'),
        },
      },
    },
  ],
```

New pages go in `pages/*.mdx`