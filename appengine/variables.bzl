"""This file is a central location for configuring new SDK versions.

"""

# Not all languages are released for every SDK version. Whenever possible, set
# ${LANG}_SDK_VERSION = APPENGINE_VERSION.
APPENGINE_VERSION = "1.9.64"

SDK_URL_PREFIX = "https://storage.googleapis.com/appengine-sdks/featured"

JAVA_SDK_SHA256 = "8eb229a6f2a1d6dbe4345ba854b7388c77abfd64af1f9fc8bdd1316811b2f8fc"

JAVA_SDK_VERSION = APPENGINE_VERSION

PY_SDK_SHA256 = "76b90b3a780c6dfd2e5dcd9d79ec8be2ab7c1146fd445e472f18e3aeb90fabc5"

# Note: Python ahead of Java
PY_SDK_VERSION = "1.9.69"

# TODO: Support other platforms besides linux
_CLOUD_SDK_BASE_URL = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads"
CLOUD_SDK_PLATFORM_ARCHIVE = "{}/google-cloud-sdk-214.0.0-linux-x86_64.tar.gz".format(
    _CLOUD_SDK_BASE_URL)
CLOUD_SDK_PLATFORM_SHA256 = "7fc406095fbb4267f4d3db3d1648a6a97b47eef7b48cee30335e29e76ef85aeb"
