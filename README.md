# WebMock::Server

[![Build Status](https://travis-ci.org/rdsubhas/webmock-server.svg?branch=master)](https://travis-ci.org/rdsubhas/webmock-server)

A fast, lightweight stub server using WebMock and Rack!

[WebMock](https://github.com/bblimke/webmock) is a popular HTTP mocking library with great features. But it has one limitation: It mocks only at the language/framework/library level (e.g. it mocks Net::HTTP directly).

This gem bridges that gap. It starts a barebones Rack application which will delegate requests to WebMock. So you get all the features of WebMock for stubbing *as well as* a running server that can return the stubbed responses. Even better, you can control the running server directly from your tests, so you can now have different stubs for different test scenarios.

## Rationale

#### vs [WebMock](https://github.com/bblimke/webmock)

WebMock is very popular and feature packed, but as explained above, it works by patching Net::HTTP (or other language-level libraries) directly. It does not come with a real HTTP server.

If you're testing a non-Ruby web app (e.g. Java) using Cucumber/Capybara, or doing black box testing, or testing a bunch of microservices - stubbing libraries is not going to work, you'll need a live server, and that's where WebMock::Server fits in.

WebMock::Server is also built on top of WebMock, so you get the full power of WebMock already!

#### vs [Stubby4J](https://github.com/azagniotov/stubby4j)

Stubby4J runs a real HTTP server, where all the stubbing configuration is defined in simple YML files. Once you've defined the YML files, you cannot change the behavior at runtime. This can be both good and bad. If you have a `/login` endpoint, and for one test you want it to return `200` and for another you want to return `400` - it becomes difficult now since the configuration is static. So you'll end up using different *data or keywords* (e.g. username/password) just to trigger different stubs, and you have to make sure that your tests don't step on each other.

Another common problem with static configuration is that, it leads to reusing same YML files for multiple tests, and this causes interdependency between tests (i.e. you change one YML and many tests get affected). And finally, you will have difficulty finding out which YML file is tied to which scenario, because its not a direct correlation.

In WebMock::Server, your stubs lie right near your steps, so there are no shared files or configurations and thus no dependencies between tests. All this because WebMock::Server can be controlled at runtime. It doesn't stop you from having shared stubs if you *really* need it though (e.g. sometimes you may want some default login/logout responses to be available all the time). If you are using RSpec - setup the shared stubs under `config.before(:each)`. Or if you're using Cucumber, use `Before` hooks. So it becomes completely obvious and under your control which ones are shared and which are not.

#### Other Tools

* [VCR](https://github.com/vcr/vcr) with [PuffingBilly](https://github.com/oesmith/puffing-billy) are not really stub servers, but they are built to record and re-run HTTP API calls. You record actual HTTP requests that hit your real application, and then Play them back during the tests. This again can be good or bad. Its good because it hits real application code. But it leads to specific ordering and dependencies in tests. And everytime you write a new test, you have to first record against a real server, so you still need to have seeding and truncating as part of your test steps. If you're testing complex applications (like a bunch of microservices), everytime you write a new test, you have to run and manage the data in multiple instances. So while replaying tests is easy, creating new tests is more complex.

* [Interfake](https://github.com/basicallydan/interfake) is very similar, and it even has a HTTP API to control the stubs (controlling HTTP over HTTP ftw). Except when it comes to actual matching of requests, its not as feature packed as WebMock.

#### Other Use Cases

Since WebMock::Server can be controlled at runtime, you can write your stubs in such a way that, whenever you get a call to create an entity, say `POST /users`, then you can automatically setup default responses for `GET /users/id`, `DELETE /users/id`, `PUT /users/id`, etc.

`TODO: Example with automatic stubs`

## Usage

* Add the gem to your Gemfile
* Start the stub server by saying `WebMock::Server.start <port>`
* Use [WebMock](https://github.com/bblimke/webmock) to stub responses, like:

        WebMock::API.stub_request("http://stubme/").to_return(status: 200, body: 'test')

  * Note that we're using the same Stub URL that we specified earlier to `WebMock::Server.start`
  * You can use the full power of WebMock such as query parameter matching, request body matching, regular expression URLs and much more!

* See the `examples` folder for some partial list of examples. But remember: You can stub whatever WebMock can! So check the WebMock guide as well on how to stub.

## Contributing

1. Fork it ( https://github.com/rdsubhas/webmock-server/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
