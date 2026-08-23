#!/usr/bin/env ruby

require "yaml"

ROOT = File.expand_path("../..", __dir__)
COMPOSE_PATH = File.join(ROOT, "compose.yaml")

def assert_equal(expected, actual, message)
  return if expected == actual

  abort("#{message}\nExpected: #{expected.inspect}\nActual:   #{actual.inspect}")
end

compose = YAML.load_file(COMPOSE_PATH)
backend = compose.fetch("services").fetch("backend")

assert_equal(
  { "context" => ".", "dockerfile" => "backend/Dockerfile" },
  backend.fetch("build"),
  "The backend must build from the repository root with backend/Dockerfile.",
)
assert_equal(
  ["127.0.0.1:8080:8080"],
  backend.fetch("ports"),
  "The backend port must only be published on loopback.",
)
assert_equal(
  "prod",
  backend.fetch("environment").fetch("BE_ENV"),
  "The container must run with production error reporting.",
)
assert_equal(
  "/run/secrets/firebase-service-account.json",
  backend.fetch("environment").fetch("GOOGLE_APPLICATION_CREDENTIALS"),
  "Firebase must use the read-only credential mount.",
)
assert_equal(
  ["ALL"],
  backend.fetch("cap_drop"),
  "The runtime container must drop Linux capabilities.",
)
assert_equal(
  true,
  backend.fetch("read_only"),
  "The runtime container filesystem must be read-only.",
)
assert_equal(
  [
    {
      "type" => "bind",
      "source" => "${FIREBASE_CREDENTIALS_PATH:-/srv/trackee/secrets/firebase-service-account.json}",
      "target" => "/run/secrets/firebase-service-account.json",
      "read_only" => true,
    },
  ],
  backend.fetch("volumes"),
  "The Firebase credential must be bind-mounted read-only from outside the repository.",
)
assert_equal(
  ["no-new-privileges:true"],
  backend.fetch("security_opt"),
  "The runtime container must prevent privilege escalation.",
)
assert_equal(
  "unless-stopped",
  backend.fetch("restart"),
  "The backend must restart after a daemon or host restart.",
)
assert_equal(
  ["/tmp:size=64m,mode=1777"],
  backend.fetch("tmpfs"),
  "The read-only runtime must retain a bounded writable temporary directory.",
)

puts "Compose deployment contract is valid."
