# Apple Sign In
The idea is for this framework to be reusable between our different projects to easily add Apple Sign In.
For now it's more of a playground though.

## Sign out
- Open the Settings app
- Click on your name (the very top option)
- -> Password & Security -> Apps Using Your Apple ID

## Server-side
- Nice illustrated overview https://drive.google.com/file/d/1G7r8W_gX_eEGVadsORLmCW1yH-3BoWE3/view
- Official documentation for server side https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_rest_api
- Official documentation to add Apple Sign in to a website https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_js
- Guide to register email domains: https://sarunw.com/posts/sign-in-with-apple-2/
- Guide to verify Apple tokens: https://sarunw.com/posts/sign-in-with-apple-3/

Basically the server needs to receive identity token, deconstruct it, validate authorization code and ultimatelly respond with our own token.
