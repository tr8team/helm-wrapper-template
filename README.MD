# Wrapper Chart Template

This template is used to create wrapper charts to deploy system applications via ArgoCD

Documentation of the chart can be found in [here](./chart/README.md)

# Change Checklist

- [ ] README.MD Title and description
- [ ] README.MD Author
- [ ] `Taskfile.yml` line 12 `RELEASE_NAME` for local testing
- [ ] `chart/Chart.tpl.yaml`'s `name`, `description`, `appVersion` and if needed, add `dependency`
- [ ] Update `chart/Chart.yaml`'s `version` to `1.0.0`
- [ ] `chart/values.tpl.yaml` and `chart/linter_values.yaml` for the new values you want to use
- [ ] `chart/templates/_helper.tpl` change all functions to your new `chart/Chart.yaml` `name` field
- [ ] Remove `chart/templates/deployment.yaml`
- [ ] Update `chart/templates/NOTES.txt` for post-installation notes

## Pre-requisite

All dependencies are pre-install via `nix` and activated via `direnv`

- [Nix](https://nixos.org/) > 2.12.0
- [direnv](https://direnv.net/) > 2.23.2
- [Docker](https://hub.docker.com/)

## Get Started

Setup the repository

```
pls setup
```

## Development

The task runner has convenience commands for development and testing

| Action                                      | Command                 |
| ------------------------------------------- | ----------------------- |
| Setup the repository                        | `pls setup`             |
| Start playground cluster to test helm chart | `pls start:cluster`     |
| Stop playground cluster                     | `pls stop:cluster`      |
| Install charts                              | `pls install`           |
| Uninstall charts                            | `pls remove`            |
| Install chart dependency                    | `pls deps`              |
| Update chart dependency                     | `pls update`            |
| Debug chart                                 | `pls debug`             |
| Publish chart                               | `pls publish <version>` |

## Quality Assurance

| Action             | Command       |
| ------------------ | ------------- |
| Running all checks | `pls check`   |
| Running formatters | `pls fmt`     |
| Running linters    | `pls lint`    |
| Running enforcers  | `pls enforce` |

## Working with CI

This template comes with in-built tools to debug CI.
CI Checks include:

- Pre Commit

### Dropping into an emulated environment

To enter an isolated CI-like environment to play around or test, run:

```
pls ci:isolate
```

If you require to enter the `nix-shell` under the `ci` attribute, you can run:

```
pls ci:isolate:nix-shell
```

### Executing specific CI

There are 3 methods to execute existing CI pipelines:

1. **Local Execution** - Execute the CI with your computer locally
2. **Emulated Environment** - Create a high-parity emulated and isolated environment to execute the CI
3. **Emulated Debug** - Like emulated, but drops you into the environment after the CI finishes for your to debug and explore

| CI         | Local Execution    | Emulated Environment       | Emulated Debug                   |
| ---------- | ------------------ | -------------------------- | -------------------------------- |
| Pre-commit | `pls ci:precommit` | `pls ci:emulate:precommit` | `pls ci:emulate:precommit:debug` |

## Authors

- [Kirinnee](mailto:kirinnee97@gmail.com)
