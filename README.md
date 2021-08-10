# Last Oasis: Ubuntu Linux / Docker based dedicated server

**WARNING:** This is pretty much a WIP Proof of Concept. Use at **your own risk!**.

This repo might help you to run dedicated servers for [Last Oasis](https://lastoasis.gg/) on Linux and/or with docker.\
You should bring basic knowledge of Linux CLI in order to utilize what we got here.

## Installation

Download this repository either via git:

```shell
git clone https://github.com/deradon/last-oasis-docker-dedicated-server
```

or via plain [download](https://github.com/Deradon/last-oasis-docker-dedicated-server/archive/refs/heads/main.zip).

## Usage

You might utilize this tool with a plain Linux (tested with Ubuntu 20.04), `docker` or `docker-compose`:

---

### Ubuntu

* Requirements: [Downloading SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD#Linux)

#### Configure

Copy the example config file and adjust it to your needs:

```shell
# Get repo (@see Installation)
cp config.example config
```

It should look close to:

<details>
  <summary>Example config</summary>

    ##############
    ## Required ##
    ##############

    # Get it from https://myrealm.lastoasis.gg/Settings ("Game server registration key")
    SERVER_CUSTOMER_KEY="XgZyB0HDYtv4JJ1tUUybXg"

    # Server name to use. Must be unique per server realm.
    SERVER_IDENTIFIER="Example Server"

    # Eternal server ip to use.
    SERVER_IP_ADDRESS=233.252.0.98

    # Server port to use. Must be unique per server realm and IP.
    SERVER_PORT="62001"

    # Get it from https://myrealm.lastoasis.gg/Settings ("Self hosted game servers registration keys")
    SERVER_PROVIDER_KEY="6fSIs5nTwnhfjcaVlZ5BmA"

    # Steam user name to login with.
    STEAM_USER="FancyAlice"

    ##############
    ## Optional ##
    ##############

    # Directory where to install Last Oasis. (Default: ".steam/last-oasis")
    # INSTALL_DIR=$(realpath ~/.steam)/last-oasis

    # Additional server options to use.
    # SERVER_OPTIONS='-log -force_steamclient_link -messaging -NoLiveServer -EnableCheats -backendapiurloverride="backend.last-oasis.com"'

    # How many slots the server should offer. (Default: "10")
    SERVER_SLOTS="25"

    # If you've compiled "stemcmd' from source or it is not included in your ${bold}PATH${normal}, you might need to set this to the full path of your "steamcmd" binary (or shell script).
    # STEAM_CMD_BINARY="steamcmdd""

    # Dedicated last oasis server steam appid for linux. (Default: "903950")
    # STEAM_LINUX_APP_ID="903950"
</details>

#### Install

When using the tool for the first time, steam ask you to login
and provide the 2FA code. That's because the Last Oasis server can not yet be downloaded
anonymously.

**IMPORTANT:** Whenever an unknown tool ask you for your password, check the source! Fight scamming and phishing!

```shell
./last-oasis install
```

#### Run

```shell
./last-oasis run
```

#### Help

```shell
./last-oasis help
```

---

### Docker

* Requirements: [Get Docker](https://docs.docker.com/get-docker/)

#### Configure

Copy the example config file and adjust it to your needs:

```shell
# Get repo (@see Installation)
cp config.example config
```

It should look close to:

<details>
  <summary>Example config</summary>

    ##############
    ## Required ##
    ##############

    # Get it from https://myrealm.lastoasis.gg/Settings ("Game server registration key")
    SERVER_CUSTOMER_KEY="XgZyB0HDYtv4JJ1tUUybXg"

    # Server name to use. Must be unique per server realm.
    SERVER_IDENTIFIER="Example Server"

    # Eternal server ip to use.
    SERVER_IP_ADDRESS=233.252.0.98

    # Server port to use. Must be unique per server realm and IP.
    SERVER_PORT="62001"

    # Get it from https://myrealm.lastoasis.gg/Settings ("Self hosted game servers registration keys")
    SERVER_PROVIDER_KEY="6fSIs5nTwnhfjcaVlZ5BmA"

    # Steam user name to login with.
    STEAM_USER="FancyAlice"

    ##############
    ## Optional ##
    ##############

    # Directory where to install Last Oasis. (Default: ".steam/last-oasis")
    # INSTALL_DIR=$(realpath ~/.steam)/last-oasis

    # Additional server options to use.
    # SERVER_OPTIONS='-log -force_steamclient_link -messaging -NoLiveServer -EnableCheats -backendapiurloverride="backend.last-oasis.com"'

    # How many slots the server should offer. (Default: "10")
    SERVER_SLOTS="25"

    # If you've compiled "stemcmd' from source or it is not included in your ${bold}PATH${normal}, you might need to set this to the full path of your "steamcmd" binary (or shell script).
    # STEAM_CMD_BINARY="steamcmdd""

    # Dedicated last oasis server steam appid for linux. (Default: "903950")
    # STEAM_LINUX_APP_ID="903950"
</details>

#### Install

When using the tool for the first time, steam ask you to login
and provide the 2FA code. That's because the Last Oasis server can not yet be downloaded
anonymously.

**IMPORTANT:** Whenever an unknown tool ask you for your password, check the source! Fight scamming and phishing!

```shell
./last-oasis-docker install
```

#### Run

```shell
./last-oasis-docker run
```

#### Help

```shell
./last-oasis-docker help
```

---

### Docker Compose

**WARNING** Experimental!

* Requirements: [Install Docker Compose](https://docs.docker.com/compose/install/)

#### Configure

Copy the example `docker-copose` file and adjust it to your needs:

```shell
# Get repo (@see Installation)
cp docker-compose.yml.example docker-compose.yml
```

**NOTE** Do NOT copy the `config.example` as this would overwrite your individual server configuration!

It should look close to:

<details>
  <summary>Example config</summary>

    version: '3.8'

    x-service-template: &service-template
      build: .
      restart: always
      command: run
      volumes:
        - "last-oasis-volume:/mnt/steam/"

    x-environment-template: &environment-template
      SERVER_CUSTOMER_KEY: XgZyB0HDYtv4JJ1tUUybXg
      SERVER_PROVIDER_KEY: 6fSIs5nTwnhfjcaVlZ5BmA
      SERVER_IP_ADDRESS: 233.252.0.98
      SERVER_SLOTS: 25
      STEAM_USER: FancyAlice

    services:
      # @note Don't remove this service. The `maintenance` service is used
      #       for installing and updating.
      maintenance:
        <<: *service-template
        restart: never
        command: help
        environment:
          <<: *environment-template


      server-01:
        <<: *service-template
        ports:
          - "62001:62001"
          - "62001:62001/udp"
        environment:
          <<: *environment-template
          SERVER_IDENTIFIER: server-01
          SERVER_PORT: 62001

      server-02:
        <<: *service-template
        ports:
          - "62002:62002"
          - "62002:62002/udp"
        environment:
          <<: *environment-template
          SERVER_IDENTIFIER: server-02
          SERVER_PORT: 62002

      server-03:
        <<: *service-template
        ports:
          - "62003:62003"
          - "62003:62003/udp"
        environment:
          <<: *environment-template
          SERVER_IDENTIFIER: server-03
          SERVER_PORT: 62003

    volumes:
      last-oasis-volume:
</details>

#### Install

When using the tool for the first time, steam ask you to login
and provide the 2FA code. That's because the Last Oasis server can not yet be downloaded
anonymously.

**IMPORTANT:** Whenever an unknown tool ask you for your password, check the source! Fight scamming and phishing!

```shell
./last-oasis-compose login
./last-oasis-compose install
```

#### Start all servers

```shell
./last-oasis-compose up
```

#### Update

```shell
./last-oasis-compose update
```

#### Stop all servers

```shell
./last-oasis-compose down
```

#### Help

```shell
./last-oasis-compose help
```

---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deradon/last-oasis-docker-dedicated-server.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Foo project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/deradon/last-oasis-docker-dedicated-server/blob/master/CODE_OF_CONDUCT.md).

## Disclaimer

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
