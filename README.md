# PayPalCheckout Sample Apps

This is a sample repository showcasing how to integrate the Native Checkout experience into your `iOS` application.

**Table of Contents**:
<!-- TOC -->  
1. [Prerequisites](#prerequisites)
    - [Application Creation](#application-creation)
    - [NVM](#nvm)
    - [Docker](#docker)
2. [Setup](#setup)
3. [Additional Info](#additional-info)
<!-- /TOC -->

## Prerequisites

### Application Creation

In order for this project to run properly we need to create an application at [PayPal Applications](https://developer.paypal.com/developer/applications/). Make sure you login and create your appropriate application. You can find additional information on our documentation [here](https://developer.paypal.com/docs/limited-release/native-checkout/setup/#obtaining-a-merchant-id). Then you need to ensure that you have a `.env` file inside the `node_checkout/` directory which contains your `CLIENT_ID` and `CLIENT_SECRET`.

We've automated away the process for you to create your `.env` file and finding / replacing any source code with the `CLIENT_ID` by running the following command:

```bash
./bin/setids "<your_client_id>" "<your_client_secret>"
```

If you do not want to expose your `CLIENT_SECRET` into your bash history, you can optionally choose to only include your `CLIENT_ID`, then bash or zsh will prompt you to enter your `CLIENT_SECRET`:

```bash
./bin/setids "CLIENT_ID"
Please enter your [client secret]: "CLIENT_SECRET"
```

### NVM

The `node checkout` service by default will run the node service through `node@10.17.0 version` and this is done through `nvm`. The `./bin/setup` script ensures that `nvm` is installed if you do not have it installed locally. If you choose to switch back to your original `node version` after running the sample demo, you can simply run `nvm use default`.

### Docker

The `node checkout` service can optionally run with Docker. You can install Docker [here](https://docs.docker.com/docker-for-mac/install/), or you can let the `./bin/setup` script install docker for you. Please note that you will require `docker-compose` support.

**Note:** You will need to ensure that Docker is running before you execute `./bin/setup`, if you are installing docker from the `./bin/setup` script you can run it again since the script will ensure Docker opens after install.

## Setup

There are two steps required to run the project:

```
1. Set Client ID / Client Secret
2. Setup Dependencies
```

The above two steps are handled by two scripts, `./bin/setids` and `./bin/setup`, respectively. Run the following commands at the _project root level_:

```bash
$ ./bin/setids "CLIENT_ID" "CLIENT_SECRET" 
# optionally just enter client id and bash will prompt for secret

$ ./bin/setup
# will run carthage, and install and programs you require
```

This activates a build script which runs the following steps:

1. Check if Homebrew, Docker (if we specified it), nvm, and Carthage are installed
2. Run `carthage update` which will download binaries for the project
3. Open the workspace, `Samples.xcworkspace`
4. Check to see if we've specified `--use-docker`
    * If we've specified `--use-docker`, we will run `docker-compose up`, this will create the container, install dependencies in container, and run on port 3000
    * If we did not specify `--use-docker` which is the default flow, then we will use `nvm` to install `node@10.17.0` then switch to that via `nvm use 10.17.0`, and finally `npm install && npm start` 

## Additional Info

The following `Search Paths` must be present under `Framework Search Paths` for both `Samples.Swift` and `Samples.Objc`:

```bash
$(PROJECT_DIR)/../Carthage/Build/iOS
```
