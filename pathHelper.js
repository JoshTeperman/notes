// pathHelpers.js

import { map, reduce, isEmpty } from 'lodash';

export const INTERNAL_PATH_NAME = 'INTERNAL_PATH_NAME';

const BASE_PATH = '/base/path';

const internalPaths = {
  [INTERNAL_PATH_NAME]: `${BASE_PATH}/internal/path/name`,
};

const externalPaths = {
  [EXTERNAL_PATH_NAME]: `${BASE_PATH}/external/path/name`,
};

const processParams = (params) => {
  if (isEmpty(params)) { return ''; }

  return `?${map((params), (key, value) => `${key}=${value}`).join('&')}`;
};

const processPathParams = (path, pathParams) => {
  return reduce((pathParams || {}), (acc, value, key) => acc.replace(`:${key}`, value), path);
};

export const getInternalPath = ({ pathName, params, pathParams }) => {
  const path = internalPaths[pathName];
  return `${processPathParams(path, pathParams)}${processParams(params)}`;
};

export const getExternalPath = ({ pathName, params, pathParams }) => {
  const path = externalPaths[pathName];

  return `${processPathParams(path, pathParams)}${processParams(params)}`;
};

// App.js

const handleRedirect = (path) => {
  window.location.href = path;
};

<Route
  path={getInternalPath({ pathName: INTERNAL_PATH_NAME })}
  render={routeProps => <ComponentName {...routeProps} {...props} handleRedirect={handleRedirect} />}
/>
