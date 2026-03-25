# ProgrammingLanguage/Java

| Field | Value |
|-------|-------|
| **Purpose** | Java-specific configuration — JDK distribution, Maven, Gradle, and keystore settings |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage/Java](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/programming-language/java@v1.0.0` |
| **Parent type** | [ProgrammingLanguage](programming-language.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `distribution` | string | JDK distribution (`openjdk`, `temurin`, `corretto`, `graalvm`, `zulu`) |
| `jvm_opts` | string | Default JVM options (e.g., `-Xmx512m -Xms256m`) |
| `java_home` | string | Explicit JAVA_HOME path |
| `maven.version` | string | Maven version to install |
| `maven.settings` | string | Path to settings.xml |
| `maven.repositories` | array of objects | Additional Maven repositories (`id`, `url`) |
| `gradle.version` | string | Gradle version to install |
| `gradle.daemon` | boolean | Enable the Gradle daemon |
| `gradle.properties` | object | Gradle properties (key-value pairs) |
| `keystore.path` | string | Path to the Java keystore file |
| `keystore.password_secret` | string | Secret reference for the keystore password |
| `keystore.type` | string | Keystore type (`JKS`, `PKCS12`) |

## Example

```yaml
_type: amadla.org/entity/programming-language/java@v1.0.0
_extends: amadla.org/entity/programming-language@v1.0.0
_body:
  language: java
  version: "21"
  version_manager: sdkman
  distribution: temurin
  jvm_opts: "-Xmx1g -Xms512m"
  maven:
    version: "3.9.6"
    settings: /etc/maven/settings.xml
    repositories:
      - id: central
        url: https://repo.maven.apache.org/maven2
  gradle:
    version: "8.5"
    daemon: true
    properties:
      org.gradle.parallel: true
      org.gradle.caching: true
  keystore:
    path: /etc/pki/java/cacerts
    password_secret: doorman://vault/java/keystore-password
    type: PKCS12
```

## Consumers

| Tool | How It Uses ProgrammingLanguage/Java |
|------|--------------------------------------|
| [lay](../tools/lay.md) | Installs JDK, Maven, Gradle, and configures keystore |
