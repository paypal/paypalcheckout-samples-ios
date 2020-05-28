#  PayPalCheckout Sample Apps

This a sample repository showcasing how to integrate the Native Checkout experience into your `iOS` application.

## Prerequisites

### Application Creation

In order for this project to run properly we need to create an application at [PayPal Applications](https://developer.paypal.com/developer/applications/). Make sure you login and create your appropriate application. You can find additional information on our documentation [here](https://developer.paypal.com/docs/limited-release/native-checkout/setup/#obtaining-a-merchant-id).

Once you've obtained your `CLIENT_ID` and your `CLIENT_SECRET` then we need to do the following steps:

- Create a `.env` file under `node_checkout/` directory which will contain your `CLIENT_ID` and `CLIENT_SECRET`. Make sure your `.env` file is not checked into version control if you plan to make a fork.

**.env**
```yaml
CLIENT_ID=my_client_id
CLIENT_SECRET=my_client_secret
```

- Replace `<client_id>` and `<redirect_uri>` in any of the source files in the projects.

### Docker

The `node checkout` service requires Docker to run properly. You can install Docker [here](https://docs.docker.com/docker-for-mac/install/). Please note that you will require `docker-compose` support so ensure you install from the official image.

## Setup

In order to setup the project run the following script at the project root directory level:

```bash
./bin/setup
```

This activates a build script which do the following steps:

1. Check if Carthage and Cocoapods are installed
2. Run `carthage update` which will download binaries for the project
3. Open the workspace, `PayPalCheckout-Samples-iOS.xcworkspace`
4. Run `docker-compose up` which will setup your container, install dependencies, and run on port 3000

## Additional Info

The following `Search Paths` must be present under `Framework Search Paths` for both `PayPalCheckout-Samples-iOS-Swift` and `PayPalCheckout-Samples-iOS-Objc`:

```bash
$(PROJECT_DIR)/../Carthage/Build/iOS
```
