npm i styled-components
// babel plugin:
// server side rendering, minification of styles, nicer debugging experience
npm i -D babel-plugin-styled-components
// then add to your .babelrc file, IUf youre using the env property in your babel configuration, then putting this plugin into the plugins array won't suffice. Instead it needs to be put into each env's plugins array to maintain it being executed first.

{
  "plugins": ["babel-plugin-styled-components"]
}

//! Structure:
const StyledComponent = syled.element`
TaggedTemplateLiteral
style: style;
`
render(
  <StyledComponent />
)


//! CONDITIONAL RENDERING:
// with props
// You can pass a function ('interpolations') to a styled component's template literal to adapt it based on its props.

const Button = styled.button`
  /* Adapt the colors based on primary prop */
  background: ${props => props.primary ? 'palevioletred' : 'white'};
  color: ${props => props.primary ? 'white' : 'palevioletred'};
  font-size: 1em;
  margin: 1em;
  padding: 0.25em 1em;
  border: 2px solid palevioletred;
  border-radius: 3px;
`

render(
  <div>
    <Button>Normal</Button>
    <Button primary>Primary</Button>
  </div>
)

const Input = styled.input`
  padding: 0.5em;
  margin: 0.5em;
  color: ${props => props.inputColor || 'palevioletred'};
  border: none;
  border-radius: 3px;
`
render(
  <div>
    <Input defaultValue='something' type='text' />
    <Input defaultValue='something else' type='text' inputColor='purple' />
  </div>
)
//! EXTENDING STYLES: styled() method
// When you want to use a component, but change it slightly for a single case.
// To easily make a new component that inherits the styling of another, just wrap it in the styled() constructor.
// eg: using the button from the last example and extending it with some color styling:

const TomatoButton = styled(Button)`
  color: tomato;
  border-color: tomato;
`
render(
  <div>
    <Button>Normal Button</Button>
    <TomatoButton>Tomato Button</TomatoButton>
  </div>
)

//! EXTENDING STYLES: 'as' polymorphic props
// When you want to change what tag or component a styled component renders
// For example, useful when you want to render a combination of links and buttons in a navbar, but with uniform styling
// eg: using the buttons above and rendering Links with the same styling:

render(
  <div>
    <Button>Normal Button</Button>
    <Button as='a' href='/'>Link with Button styles</Button>
    <TomatoButton as='a' href='/'>Link with Tomato Button styles</TomatoButton>
  </div>
)

// can be used with custom components as well:

const ReversedButton = (props) => {
  <Button 
    {...props} 
    children={props.children.split('').reverse()}
  />
}

render(
  <Button as={ReversedButton}>Custom Reversed Button</Button>
)

// should render with Button styles and reversed text 'nottuB desreveR motsuC'

//! EXTENDING STYLES: styling any component using styled() and passing className prop

const Link = ({ className, children }) = (
  <a className={className}>
    {children}
  </a>
);
const StyledLink = styled(Link)`
  color: palevioletred;
  font-weight: bold;
`;
render(
  <div>
    <Link>Unstyled, boring Link</Link>
    <StyledLink>Styled, exciting Link</StyledLink>
  </div>
);

// You can alsopass tag names into the styled() factory call
styled('div')
// styled.tagname helpers are just aliases that do the same thing

//! ATTRS constructor: Attaching additional props

// to avoid unnecessary wrappers that just pass on some props to the rendered component, or element, you can use the .attrs constructor. It allows you to attach additional props, or 'attributes' to a component.
// saves us from having to repeatedly add props or attributes to our JSX that cannot be written within a String Literal (which contain CSS properties)
// This way you can for example attach static props to an element, or pass a third-party prop like `activeClassName` to React Router's `Link` Component.
// The .attrs() object also takes functions that receive the props that the component receives. The return value will be merged into the resulting props as well.

const Input = styled.input.attrs(props => ({
  // we can define static props
  type: 'password',
  // or we can define dynamic ones
  size: props.size || '1em',
}))`
  color: red;
  font-size: 1em;
  border: 2px solid palevioletred;
  border-radius: 3px;
  /* here we use the dynamically computed prop */
  margin: ${props => props.size};
  padding: ${props => props.size}
`;

// now if size='' props are passed into the Input component it will be passed to margin and padding
// because we have `type='password'` in the attrs() constructor, we don't need to add it to each <Input> component

render(
  <div>
    <Input placeholder='A small text input' />
    <Input placeholder='A bigger text input' size='2em' />
  </div>
)

// ... to provide a flexible Input component that defaults to password but can be something else, you could do:
const Input = styled.input.attrs(({ type, size }) => ({
  type: type || 'password'
  ...
})

//! THEMES
import styled, { ThemeProvider } from 'styled-components'
import theme from 'styled-theming'
// 

const boxBackgroundColor = theme('mode', {
  light: '#fff',
  dark: '#000'
})

const Box = styled.div`
  background-color: ${boxBackgroundColor}
`
export default App = () => {
  return(
    <ThemeProvider theme={{ mode: 'light' }}>
      <Box>Hello World</Box>
    </ThemeProvider>
  )
}

import { ThemeConsumer } from 'styled-components'
// This is the 'consumer' component created by react.createContext as the companion component to `ThemeProvider`.
// It uses the `render prop pattern` to allow for dynamic access to the theme during rendering.
// It passes the current theme (based on a ThemeProvider higher in your component tree) as an argument to the child function. From this function, you may return further JSX or nothing

render() {
  return (
    <ThemeConsumer>
      {theme => <div>The theme color is {theme.color}.</div>}
    </ThemeConsumer>
  )
}
// note: all styled components automatically receive the theme as a prop, so this is only necessary if you wish to access the theme for other reasons.


//! HELPERS: GLOBAL STYLES createGlobalStyle``
//! HELPERS: css ``
//! HELPERS: keyframs``


//! JEST Integration

npm i -D jest-styled-components

// snapshots
import renderer from 'react-test-renderer'
import 'jest-styled-components'

const Button = styled.button`color: red;`

test('it works', () => {
  const tree = renderer.create(<Button />).toJSON()
  expect(tree).toMatchSnapshot()
}

// toHaveStyleRule: test if styles have been applied or not
// takes two required paramaters (property: String, value: String or RegExp) and an optional object
// optional object used to search for rules nested within an at-rule or to add modifiers to the class selector

import renderer from 'react-test-renderer'
import 'jest-styled-components'

const Button = styled.button`
  color: red;
  @media (max-width: 640px) {
    &:hover {
      color: green;
    }
  }
`
test('it works', () => {
  const tree = renderer.create(<Button />).toJSON()
  expect(tree).toHaveStyleRule('color', 'red')
  expect(tree).toHaveStyleRule('color', 'green', {
    media: '(max-width: 640px)',
    modifier: ':hover',
  })
})
