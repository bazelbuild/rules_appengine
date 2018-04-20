"""This file is a central location for configuring new SDK versions.
"""
# Not all languages are released for every SDK version. Whenever possible, set
# ${LANG}_SDK_VERSION = APPENGINE_VERSION.
APPENGINE_VERSION = "1.9.63"

SDK_URL_PREFIX = "https://storage.googleapis.com/appengine-sdks/featured"

JAVA_SDK_SHA256 = "477eb0bdec2c98fa68e4d0d9cbd1329c140e907fa64be2c3c9c065373369e93b"

JAVA_SDK_VERSION = APPENGINE_VERSION

PY_SDK_SHA256 = "76b90b3a780c6dfd2e5dcd9d79ec8be2ab7c1146fd445e472f18e3aeb90fabc5"

# Note: Python ahead of Java
PY_SDK_VERSION = "1.9.69"
