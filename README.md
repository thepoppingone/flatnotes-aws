# Flatnotes on AWS

Forked from <https://github.com/dullage/flatnotes> and modified it for test purposes.

## Tools

- Terraform
- Docker
- GitHub Actions
- AWS ECS
- AWS ECR

## Pre-requisites

1. An existing AWS VPC
2. At least two public subnets the above mentioned VPC
3. Valid AWS Access Keys and Secret Keys for ECR deployment workflow (A temp solution, would use IAM roles GitHub OIDC when possible)

## Basic Architecture

![Arch](image.png)

## Deployment steps

1. Modify the following block in the terraform folder's `flatnotes.tf` to the VPC ID and Public Subnet IDs in the AWS Account, connect to AWS account either using AWS Access Keys or AWS CLI login, then run `terraform apply` from `terraform` folder.

```
module "flatnotes_infra" {
  source = "./modules/flatnotes"

  vpc_id             = "vpc-05d23fd53c23eaba6" # Change me
  public_subnets_ids = ["subnet-0e836ff84212395c8", "subnet-0007831a1dea41b89", "subnet-02e7925c27ca569b0"] # Change me
  deploy             = false # can only set to true after ECR has image pushed
}
```

2. Trigger the Docker Build and Push pipeline at [Workflow](https://github.com/thepoppingone/flatnotes-aws/actions/workflows/buildandpushecr.yml), proceed to step 3 only when run is successful, make sure AWS_ACCESS_KEY, AWS_SECRET_KEY and AWS_REGION secrets in GitHub Actions are modified to a working AWS account. Modify the secrets at [this link](https://github.com/thepoppingone/flatnotes-aws/settings/secrets/actions)
![PushECR](image-1.png)

3. Once that is done, update the block `deploy` variable value to `true` and run `terraform apply`. Deployment can take up to 5 mins. 3 mins to setup the service, another 2 mins max for the container to be ready.

```
  vpc_id             = "vpc-05d23fd53c23eaba6" # Change me
  public_subnets_ids = ["subnet-0e836ff84212395c8", "subnet-0007831a1dea41b89", "subnet-02e7925c27ca569b0"] # Change me
  deploy             = true # can only set to true after ECR has image pushed
```

4. To undeploy run `terraform destroy`

# Original README from Flatnotes owner

<p align="center">
  <img src="docs/logo.svg" width="300px"></img>
</p>
<p align="center">
  <img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/dullage/flatnotes?style=for-the-badge">
</p>

A self-hosted, database-less note-taking web app that utilises a flat folder of markdown files for storage.

Log into the [demo site](https://demo.flatnotes.io) and take a look around. *Note: This site resets every 15 minutes.*

## Contents

- [Design Principle](#design-principle)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Hosted](#hosted)
  - [Self Hosted](#self-hosted)
- [Roadmap](#roadmap)
- [Sponsorship](#sponsorship)
- [Thanks](#thanks)

## Design Principle

flatnotes is designed to be a distraction-free note-taking app that puts your note content first. This means:

- A clean and simple user interface.
- No folders, notebooks or anything like that. Just all of your notes, backed by powerful search and tagging functionality.
- Quick access to a full-text search from anywhere in the app (keyboard shortcut "/").

Another key design principle is not to take your notes hostage. Your notes are just markdown files. There's no database, proprietary formatting, complicated folder structures or anything like that. You're free at any point to just move the files elsewhere and use another app.

Equally, the only thing flatnotes caches is the search index and that's incrementally synced on every search (and when flatnotes first starts). This means that you're free to add, edit & delete the markdown files outside of flatnotes even whilst flatnotes is running.

## Features

- Mobile responsive web interface.
- Raw/WYSIWYG markdown editor modes.
- Advanced search functionality.
- Note "tagging" functionality.
- Wikilink support to easily link to other notes (`[[My Other Note]]`).
- Light/dark themes.
- Multiple authentication options (none, read-only, username/password, 2FA).
- Restful API.

See [the wiki](https://github.com/dullage/flatnotes/wiki) for more details.

## Getting Started

### Hosted

A quick and easy way to get started with flatnotes is to host it on PikaPods. Just click the button below and follow the instructions.

[![PikaPods](https://www.pikapods.com/static/run-button-34.svg)](https://www.pikapods.com/pods?run=flatnotes)

### Self Hosted

If you'd prefer to host flatnotes yourself then the recommendation is to use Docker.

### Example Docker Run Command

```shell
docker run -d \
  -e "PUID=1000" \
  -e "PGID=1000" \
  -e "FLATNOTES_AUTH_TYPE=password" \
  -e "FLATNOTES_USERNAME=user" \
  -e "FLATNOTES_PASSWORD=changeMe!" \
  -e "FLATNOTES_SECRET_KEY=aLongRandomSeriesOfCharacters" \
  -v "$(pwd)/data:/data" \
  -p "8080:8080" \
  dullage/flatnotes:latest
```

### Example Docker Compose

```yaml
version: "3"

services:
  flatnotes:
    container_name: flatnotes
    image: dullage/flatnotes:latest
    environment:
      PUID: 1000
      PGID: 1000
      FLATNOTES_AUTH_TYPE: "password"
      FLATNOTES_USERNAME: "user"
      FLATNOTES_PASSWORD: "changeMe!"
      FLATNOTES_SECRET_KEY: "aLongRandomSeriesOfCharacters"
    volumes:
      - "./data:/data"
      # Optional. Allows you to save the search index in a different location:
      # - "./index:/data/.flatnotes"
    ports:
      - "8080:8080"
    restart: unless-stopped
```

See the [Environment Variables](https://github.com/dullage/flatnotes/wiki/Environment-Variables) article in the wiki for a full list of configuration options.

## Roadmap

I want to keep flatnotes as simple and distraction-free as possible which means limiting new features. This said, I welcome feedback and suggestions.

## Sponsorship

If you find this project useful, please consider buying me a beer. It would genuinely make my day.

[![Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/Dullage)

## Thanks

A special thanks to 2 fantastic open-source projects that make flatnotes possible.

- [Whoosh](https://whoosh.readthedocs.io/en/latest/intro.html) - A fast, pure Python search engine library.
- [TOAST UI Editor](https://ui.toast.com/tui-editor) - A GFM Markdown and WYSIWYG editor for the browser.
