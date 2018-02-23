[![Build status](https://badge.buildkite.com/98ffeea8dc7631a8a7d7af13cbe7570a7209a98ef18fe3cbc5.svg)](https://buildkite.com/bazel/appengine-rules-appengine-postsubmit)


# App Engine Rules for Bazel

<div class="toc">
  <h2>Rules</h2>
  <ul>
    <li><a href="#appengine_war">appengine_war</a></li>
    <li><a href="#java_war">java_war</a></li>
    <li><a href="#py_appengine_binary">py_appengine_binary</a></li>
    <li><a href="#py_appengine_test">py_appengine_test</a></li>
  </ul>
</div>

## Overview

These build rules are used for building
[Java App Engine](https://cloud.google.com/appengine/docs/java/) application or
[Python App Engine](https://cloud.google.com/appengine/docs/python/) application
with Bazel. It does not aim at general web application
support but can be easily modified to handle a standard web application.

<a name="setup"></a>
## Setup

To be able to use the Java App Engine rules, you must make the App Engine SDK
available to Bazel. The easiest way to do so is by adding the following to your
`WORKSPACE` file:

```python
git_repository(
    name = "io_bazel_rules_appengine",
    remote = "https://github.com/bazelbuild/rules_appengine.git",
    # Check https://github.com/bazelbuild/rules_appengine/releases for the latest version.
    tag = "0.0.4",
)
# Java
load("@io_bazel_rules_appengine//appengine:appengine.bzl", "appengine_repositories")
appengine_repositories()
# Python
load("@io_bazel_rules_appengine//appengine:py_appengine.bzl", "py_appengine_repositories")
py_appengine_repositories()
```

The AppEngine rules download the AppEngine SDK, which is a few hundred megabytes
in size. To avoid downloading this multiple times for multiple projects or
inadvertently re-downloading it, you might want to add the following line to
your `$HOME/.bazelrc` file:

```
build --experimental_repository_cache=/home/user/.bazel/cache
```

<a name="basic-example"></a>
## Basic Example

Suppose you have the following directory structure for a simple App Engine
application:

```
[workspace]/
    WORKSPACE
    hello_app/
        BUILD
        java/my/webapp/
            TestServlet.java
        webapp/
            index.html
        webapp/WEB-INF
            web.xml
            appengine-web.xml
```

### BUILD definition

Then, to build your webapp, your `hello_app/BUILD` can look like:

```python
load("@io_bazel_rules_appengine//appengine:appengine.bzl", "appengine_war")

java_library(
    name = "mylib",
    srcs = ["java/my/webapp/TestServlet.java"],
    deps = [
        "//external:appengine/java/api",
        "@io_bazel_rules_appengine//appengine:javax.servlet.api",
    ],
)

appengine_war(
    name = "myapp",
    jars = [":mylib"],
    data = glob(["webapp/**"]),
    data_path = "webapp",
)
```

For simplicity, you can use the `java_war` rule to build an app from source.
Your `hello_app/BUILD` file would then look like:

```python
load("@io_bazel_rules_appengine//appengine:appengine.bzl", "java_war")

java_war(
    name = "myapp",
    srcs = ["java/my/webapp/TestServlet.java"],
    data = glob(["webapp/**"]),
    data_path = "webapp",
    deps = [
        "//external:appengine/java/api",
        "@io_bazel_rules_appengine//appengine:javax.servlet.api",
    ],
)
```

You can then build the application with `bazel build //hello_app:myapp`.

### Run on a local server

You can run it in a development server with `bazel run //hello_app:myapp`.
This will bind a test server on port 8080. If you wish to select another port,
use the `--port` option:

```
bazel run //hello_app:myapp -- --port=12345
```

You can see other options with `-- --help` (the `--` tells Bazel to pass the
rest of the arguments to the executable).

### Deploy to Google App Engine

Another target `//hello_app:myapp.deploy` allows you to deploy your
application to App Engine. It takes an optional argument: the
`APP_ID`. If not specified, it uses the default `APP_ID` provided in
the application. This target needs to open a browser to authenticate
with AppEngine, then have you copy-paste a "key" from the browser in
the terminal. Since Bazel closes standard input, you can only input
this by building the target and then running:

```
$ bazel-bin/hello_app/myapp.deploy APP_ID
```

After the first launch, subsequent launch will be registered to
App Engine so you can just do a normal `bazel run
//hello_app:myapp.deploy -- APP_ID` to deploy next versions of
your application.

*Note:* AppEngine uses Java 7. If you are using a more recent version of Java,
you will get the following error message when you try to deploy:

```
java.lang.IllegalArgumentException: Class file is Java 8 but max supported is Java 7
```

To build with Java 7, use the toolchain bundled with these AppEngine rules:

```
$ bazel build --java_toolchain=@io_bazel_rules_appengine//appengine:jdk7 //my-project
```

To avoid having to specify this toolchain during every build, you can add this
to your project's `.bazelrc`.  Create a `.bazelrc` file in the root directory of
your project and add the line:

```
build --java_toolchain=@io_bazel_rules_appengine//appengine:jdk7
```

<a name="appengine_war"></a>
## appengine_war

```python
appengine_war(name, jars, data, data_path)
```

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>Name, required</code>
        <p>A unique name for this rule.</p>
      </td>
    </tr>
    <tr>
      <td><code>jars</code></td>
      <td>
        <code>List of labels, required</code>
        <p>
          List of JAR files that will be uncompressed as the code for the
          Web Application.
        </p>
        <p>
          If it is a `java_library` or a `java_import`, the
          JAR from the runtime classpath will be added in the `lib` directory
          of the Web Application.
        </p>
      </td>
    </tr>
    <tr>
      <td><code>data</code></td>
      <td>
        <code>List of files, optional</code>
        <p>List of files used by the Web Application at runtime.</p>
        <p>
          This attribute can be used to specify the list of resources to
          be included into the WAR file.
        </p>
      </td>
    </tr>
    <tr>
      <td><code>data_path</code></td>
      <td>
        <code>String, optional</code>
        <p>Root path of the data.</p>
        <p>
          The directory structure from the data is preserved inside the
          WebApplication but a prefix path determined by `data_path`
          is removed from the the directory structure. This path can
          be absolute from the workspace root if starting with a `/` or
          relative to the rule's directory. It is set to `.` by default.
        </p>
      </td>
    </tr>
  </tbody>
</table>

<a name="java_war"></a>
## java_war

```python
java_war(name, data, data_path, **kwargs)
```

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>Name, required</code>
        <p>A unique name for this rule.</p>
      </td>
    </tr>
    <tr>
      <td><code>data</code></td>
      <td>
        <code>List of labels, optional</code>
        <p>List of files used by the Web Application at runtime.</p>
        <p>Passed to the <a href="#appengine_war">appengine_war</a> rule.</p>
      </td>
    </tr>
    <tr>
      <td><code>data_path</code></td>
      <td>
        <code>String, optional</code>
        <p>Root path of the data.</p>
        <p>Passed to the <a href="#appengine_war">appengine_war</a> rule.</p>
      </td>
    </tr>
    <tr>
      <td><code>**kwargs</code></td>
      <td>
        <code>see <a href="http://bazel.io/docs/be/java.html#java_library">java_library</a></code>
        <p>
          The other arguments of this rule will be passed to build a `java_library`
          that will be passed in the `jar` arguments of a
          <a href="#appengine_war">appengine_war</a> rule.
        </p>
      </td>
    </tr>
  </tbody>
</table>

<a name="py_appengine_binary"></a>
## py_appengine_binary
```python
py_appengine_binary(name, srcs, configs, deps=[], data=[])
```
<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>Name, required</code>
        <p>A unique name for this rule.</p>
      </td>
    </tr>
    <tr>
      <td><code>configs</code></td>
      <td>
        <code>List of labels, required</code>
        <p>the path to your app.yaml/index.yaml/cron.yaml files</p>
      </td>
    </tr>
    <tr>
      <td><code>srcs</code></td>
      <td>
        <code>List of labels, optional</code>
        <p>The list of source files that are processed to create the target. </p>
      </td>
    </tr>
    <tr>
      <td><code>deps</code></td>
      <td>
        <code>List of labels, optional</code>
        <p>The list of libraries to link into this library. </p>
      </td>
    </tr>
    <tr>
      <td><code>data</code></td>
      <td>
        <code>List of labels, optional</code>
        <p>List of files used by the Web Application at runtime.</p>
      </td>
    </tr>
  </tbody>
</table>

<a name="py_appengine_test"></a>
## py_appengine_test
```python
py_appengine_test(name, srcs, deps=[], data=[], libraries={})
```
<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>Name, required</code>
        <p>A unique name for this rule.</p>
      </td>
    </tr>
    <tr>
      <td><code>srcs</code></td>
      <td>
        <code>List of labels, required</code>
        <p>The list of source files that are processed to create the target. </p>
      </td>
    </tr>
    <tr>
      <td><code>deps</code></td>
      <td>
        <code>List of labels, optional</code>
        <p>The list of libraries to link into this library. </p>
      </td>
    </tr>
    <tr>
      <td><code>data</code></td>
      <td>
        <code>List of labels, optional</code>
        <p>List of files used by the Web Application at runtime.</p>
      </td>
    </tr>
    <tr>
      <td><code>libraries</code></td>
      <td>
        <code>dict, optional</code>
        <p>dictionary of name and the corresponding version for third-party libraries required from sdk.</p>
      </td>
    </tr>
  </tbody>
</table>

## Using a local AppEngine SDK

### Java

If you already have a local copy of the AppEngine SDK, you can specify the path to
that in your WORKSPACE file (instead of Bazel downloading another copy):

```
load('@io_bazel_rules_appengine//appengine:appengine.bzl', 'APPENGINE_BUILD_FILE')
new_local_repository(
    name = 'com_google_appengine_java',
    path = '/path/to/appengine-java-sdk-version',
    build_file_content = APPENGINE_BUILD_FILE,
)
```


### Python

You can, optionally, specify the environment variable PY_APPENGINE_SDK_PATH to use
an SDK that is on your filesystem (instead of downloading a new one).

```
PY_APPENGINE_SDK_PATH=/path/to/appengine-python-sdk-1.9.50 bazel build //whatever
```
