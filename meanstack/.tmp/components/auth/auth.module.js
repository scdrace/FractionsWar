'use strict';

angular.module('meanstackApp.auth', ['meanstackApp.constants', 'meanstackApp.util', 'ngCookies', 'ui.router']).config(function ($httpProvider) {
  $httpProvider.interceptors.push('authInterceptor');
});
//# sourceMappingURL=auth.module.js.map
