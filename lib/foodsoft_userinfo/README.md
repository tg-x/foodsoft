= FoodsoftUserinfo

Simple userinfo endpoint for using foodsoft authentication with external systems.
Loosely modeled on [OpenID Connect Lite's idea](http://openid.net/specs/openid-connect-lite-1_0-08.html#userinfo).

`https://foodcoop.test/:foodcoop/login/userinfo` will return JSON data, user information
when the user is logged in, an error when not.
