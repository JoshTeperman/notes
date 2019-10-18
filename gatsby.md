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

### Configuration

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

### Writing MDX

- same as React, just import components and add them <Component />
- can add Markdown content to a component as long as you include a full line break either side

```
// Use a React component 

import Blah from '../components/Blah';

<Blah />

### Some Markdown

```

```
// Custom Markdown inside component

<div style={{ background: 'red' }}>

# This is markdown

</div>
```

## Blog

Install plugin that allows you to use local files as a data layer.<br>
Gatsby will search for a folder with the path name. 

`npm i gatsby-source-filesystem`
```
plugins: [
  {
    resolve: 'gatsby-source-filesystem',
    options: {
      name: 'posts',
      path: 'posts', 
    }

  }
]
```

```
// posts/00-blog-title/00-blog-title.mdx
---
// frontmatter (YAML)

title: Blog Title
slug: url-the-page-will-have
author: me
---

// Content

Hello World
```
New pages go in `pages/*.mdx` 


## gatsby-node.js

Has access to actions, graphql, reporter in props. Actions provides createPage function used to create new pages. 

Configure path, component, and optional context (used to pass additional data to be used in the page and available as props or as GraphQl variable). Recommendation is to pass the slug through context, and use that to make a separate graphql query to fetch additional data within page component. 

```
exports.createPages = async ({ actions, graphql, reporter }) => {
  const result = await graphql(`
    query {
      allMdx {
        nodes {
          frontmatter {
            slug
          }
        }
      }
    }
  `);

  if (result.errors) {
    reporter.panic('failed to create posts', result.errors);
  }

  const posts = result.data.allMdx.nodes;

  posts.forEach(post => {
    actions.createPage({
      path: post.frontmatter.slug,
      component: require.resolve('./src/templates/post.js'),
      context: {
        slug: `/${post.frontmatter.slug}/`,
      },
    });
  });
};

```

## Query your posts

```
// filter by slug and retrieve a single mdx file
// anything returned from graphql query will be accessible ({ data })
// templates/post.js

export const query = graphql`
  query($slug: String) {
    mdx(frontmatter: { slug: { eq: $slug }}) {
      frontmatter {
        title
        author
      }
      body
    }
  }
`;

// to render body, use MDX renderer, otherwise destructure from the data object:

import { MDXRenderer } from 'gatsby-plugin-mdx';

const PostTemplate = ({ data: { mdx: post } }) => (
  <Layout>
    <h1>{post.frontmatter.title}</h1>
    <p
      css={css`
        font-size: 0.75rem;
      `}
    >
      Posted by {post.frontmatter.author}
    </p>
    <MDXRenderer>{post.body}</MDXRenderer>
    <ReadLink to="/">&larr; Back to all posts</ReadLink>
  </Layout>
);


```

```
// filter all files to find the files with source name "posts"
// this refers to name: "posts" in gatsby-config.js
// to source multiple differene filesystems, simply duplicate the resolve with different name/path value.

query {
  allFile(filter: { sourceInstanceName: {eq: "posts"}}) {
    nodes {
      childMdx {
        frontmatter {
          title
          author
        }
        body
      }
    }
  }
}
```