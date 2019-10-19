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
    },
  },
  {
    resolve: 'gatsby-source-filesystem',
    options: {
      name: 'images',
      path: 'images', 
    },
  },
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

# Images
USING GATSBY IMAGE: https://using-gatsby-image.gatsbyjs.org/

`npm i gatsby-plugin-sharp`<br>
https://www.gatsbyjs.org/packages/gatsby-plugin-sharp/<br>
Installs the sharp package and makes several sharp processing functions available from the sharp processing library.


`npm i gatsby-transformer-short`<br>
Will look for image nodes and apply Sharp image transformations to them<br>
Will create ImageSharp nodes when it finds files with image extensions that has a reference to all the images created with gatsby-plugin-sharp

`npm i gatsby-background-image`<br>
Optimised component that provides optimised performance, blur-on-load, container-use, styled-components-compatible

takes `fluid` (For when you want an image that stretches across a fluid width container but will download the smallest image needed for the device e.g. a smartphone will download a much smaller image than a desktop device), and `fadeIn` image props

## Querying sharp images
https://stackoverflow.com/questions/50141031/gatsby-image-difference-between-childimagesharp-vs-imagesharp

https://www.gatsbyjs.org/packages/gatsby-plugin-sharp/

An `ImageSharp` node is the node created by gatsby-plugin-sharp (name `ChildImageSharp` when referenced by a parent file) is created in a parent-child relationships with any Image file. `ImageSharp` includes a `fluid` field that returns fluid width sizes for the image, as well as base64, originalImg<br>
`ImageSharp`

File > ChildImageSharp > fluid

A ChildImageSharp doesn't know it's location in the file system so much be called in reference to it's parent image.

```
query {
  file(relativePath: { eq: "filename.jpg" } {
    childImageSharp {
      fluid {
        // files available here
        src
      }
    }
  }
}
```

You can also query multiple images with `allFile` and either `edges > node > childImageSharp` or `nodes > childImageSharp`
```
query {
  allFile(filter: { sourceInstanceName: {eq: "source-file-system-alias"}}) {
    edges {
      node {
        fluid {
          src
        }
      }
    }
  }
}
```

### Example setup: combinded with React to display background image on Hero component:

```
// gatsby-config.js -> configure filesystem path

{
  resolve: 'gatsby-source-filesystem`,
  options: {
    name: 'images',
    path: 'images',
  }
}
```

```
// Hero.js 
// -> create Background Image with gatsby-background-image and @emotion/styled libraries
// -> create graphql query for fluid images node created by gatsby-sharp-plugin and add to BackgroundImage
// -> fragment `...GatsbyImageSharpFluid_withWebp` 
// -> fadeIn="soft" fade-in animation

import React from 'react';
import styled from '@emotion/styled';
import { graphql, useStaticQuery } from 'gatsby';
import BackgroundImage from 'gatsby-background-image';

const BackgroundImage = styled(ImageBackground)``

const Hero = () => {

  const { image } = useStaticQuery(graphql`
    query {
      image: file(relativePath: { eq: "file-name.jpg"}) {
        sharp: childSharpImage {
          fluid {
            ...GatsbyImageSharpFluid_withWebp
          }
        }
      }
    }
  `);

  return (
    <BackgroundImage Tag="section" fluid={image.sharp.fluid} fadeIn="soft">
      <TextBox />
    </BackgroundImage>
  )
}
```
### Example Setup #2: Displaying thumbnail photos from frontmatter src

```
// useFrontMatterImage.js
// -> use hook to return image object using graphql query and frontmatter key
// -> setting max-height and max-width 

const useFrontMatterImage = () => {
  const data = useStaticQuery(graphql`
    query {
      allMdx {
        nodes {
          frontmatter {
            slug
            image {
              sharp: childImageSharp {
                fluid(maxHeight: 100, maxWidth: 100) {
                  ...GatsbyImageSharpFluid_withWebp
                }
              }
            }
          }
        }
      }
    }
  `);

  return data.allMdx.nodes.map(post => ({
    slug: post.frontmatter.slug,
    image: post.frontmatter.image,
  }));
}
```

```
// index.js
// -> retrieve data using useFrontMatterImage() hook and pass to ImagePreview component

export default () => {
  const images = useFrontMatterImage();

  return (
    {posts.map(post => (
        <ImagePreview post={post} key={post.slug} />
    }
  );
};
```

```
// ImagePreview.js
// -> receives image data as prop and renders gatsby-image component

import Image from 'gatsby-image';

const ImagePreview = ({ post }) => (
  <Link to={post.slug}>
    <Image fluid={post.image.sharp.fluid} />
  </Link>
);

```

## Render Images in syntactic Markdown

When you want to use markdown format: `![ALT](src)` instead of MDX

Need gatsby plugin `gatsby-remark-images`. Remark is a Markdown parser that can convert Markdown files into HTML. MDX is also compatible with the remark plugins.

Will still work with gatsby-image and provide sharp Image optimisations.

```
// gatsby-config.js
// -> add configuration to gatsby-mdx

...
resolve: 'gatsby-plugin-mdx,
options: {
  default-layouts: {
    default: require(resolve('./src/components/layout.js'))
  },
  gatsbyRemarkPlugins: [{ resolve: 'gatsby-remark-images' }],
  plugins: [{ resolve: 'gatsby-remark-images' }],
  ,
},

// -> Can now use ![Image](src) syntax
```

## Image Processing

https://image-processing.gatsbyjs.org/

https://www.gatsbyjs.org/packages/gatsby-plugin-sharp/
```
fluid (
  //options
  maxHeight: 100
  maxWidth: 100
  grayscale
  toFormat: PNG
  resize(width: 125, height: 125, rotate: 180)
  duotone { highlight: "#f00e2e", shadow: "#192550", opacity: 50}
) {
  // images
}

// When both a maxWidth and maxHeight are provided, sharp will use COVER as a fit strategy by default. This might not be ideal so you can now choose between COVER, CONTAIN and FILL as a fit strategy.
```

# Query Fragments
https://www.gatsbyjs.org/docs/graphql-api/

Fragments allow you to reuse parts of GraphQL queries. They also allow you to split up complex queries into smaller, easier to understand components.

Some fragments come included in Gatsby plugins, such as fragments for returning optimized image data in various formats with gatsby-image and gatsby-transformer-sharp, or data fragments with gatsby-source-contentful.

```
// GatsbyImageSharpFixed
* "The simplest set of fields for fixed sharp images"

export const GatsbyImageSharpFixed = graphql`
  fragment GatsbyImageSharpFixed on ImageSharpFixed {
    base64
    width
    height
    src
    srcSet
  }
`
```
```
// GatsbyImageSharpFluid_withWebp
* "Fluid images that prefer Webp"
* WebP is an image format  developed by Google employing both lossy and lossless compression.

export const GatsbyImageSharpFluid_withWebp = graphql`
  fragment GatsbyImageSharpFluid_withWebp on ImageSharpFluid {
    base64
    aspectRatio
    src
    srcSet
    srcWebp
    srcSetWebp
    sizes
  }
`
```

# Source Plugins

## Instagram

`npm i gatsby-source-instagram`

```
// resolve plugin
resolve: `gatsby-source-instagram`,
options: {
  username: 'tepermansalad'
},
options: {
  type: `hashtag`,
  hashtag: 'catsofinstagram',
},
```
```
query {
  allInstaNode(limit: 12) {
    nodes {
      id
      caption
      username
      localFile {
        sharp: childImageSharp {
          fluid(maxHeight: 150, maxWidth: 150) {
            ...GatsbyImageSharpFluid_withWebp
          }
        }
      }
    }
  }
}
```

# Extending
- Comments / Forms
  - Typeform
  - Formspree
  - Netlify forms 
  - Staticman
  - Discus
- Search
  - Algolia
  - Google Custom Search
- Headless CMS
  - Strapi
  - Ghost
  - Netlify CMS
  - Contentful
- eCommerce / Cart
  - Snipcart
- Authentication
  - Netlify user-login
- Backend functions
  - Serverless