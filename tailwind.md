## Tailwindcss installation in Rails 6

Install Tailwind

`yarn add tailwindcss`

Add tailwind stylesheets

```javascript
// app/javascript/stylesheets/application.scss

@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";
```

import your new `application.scss` file into your javascript assets so they compile with webpack
```javascript
// app/javascript/packs/application.js

import '../stylesheets/application.scss'
```

Add your tailwind plugins to postcss processor

```javascript
// postcss.config.js

require('tailwindcss'),
require('autoprefixer'),
```

