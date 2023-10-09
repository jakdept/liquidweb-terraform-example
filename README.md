# Terraform Examples

This repository contains terraform examples that are slated for inclusion in the terraform repository elsewhere, but not yet ready.
I will likely archive / remove it in the future when they are at a place where they can be merged into `liquidweb/terraform-provider-liquidweb`.

## What is Terraform?

Terraform is a tool targeted at a Infrastructure as Code approach to managing asset inventory.
It offers a declarative language to create configurations describing infrastructure.
Given the configurations, you can rapidly create, remove, and recreate infrastructure.
Since the configuraitons are plaintext, it allows easy versioning of the infrastructure state with Version Control Software.

### Background Terms

That's a loaded paragraph, some terminology:

- Version Control Software (vcs) - like `git`, a tool that lets you track files over time and compare differences
  - Of note, most developers put their source code in VCS. This has many benefits.
- Infrastructure as Code (IaC) - managing servers via config files, often which you can commit to a repository
- Declarative Syntax / Language - describing what an system should be
- Asset Inventory - what assets you have. VPS's are an asset, but SSL certificates, LB's, and Block Storage are also assets.
- configuration files end in `.tf` and determine what is needed
- State - the current way a system is, the actual live snapshot of it, not the way it hsould be
- Lockfile - a file tracking what things terraform currently has

### Terraform Basic Commands

The focus of Terraform is create, recreate, and destroying what is needed.
Terraform can be used alone, and assets recreated as your schema changes.
But most of the time, multiple IaC tools are used to better describe a system.

The major background pieces it will create are:

- the lock file resides at `./.terraform.lock.hcl`
- the state file resides at `./terraform.tfstate`
- a backup state file at `./terraform.tfstate.backup`
- providers typically reside in `./terraform.d`

If you have something deployed, you want to save the

The major commands that terraform provides are:

- `init` - download required providers and set up state and lockfile
- `validate` - make sure configs are valid
- `plan` - show changes to modify state to match configs
- `apply` - run `plan`, then prompt to make those changes
- `destroy` show changes to remove everything, prompt, then remove everything
- `show` - display the current assets
- `taint` - mark an asset currently deployed, on next `apply` will be recreated
- `refresh` - update the state of assets (not supported with LiquidWeb's provider)
- `import` - add existing assets into current state (not supported with LiquidWeb's provider)

Terraform Modules also exist.
For example, [there is a wordpress module](https://registry.terraform.io/providers/yyamanoi1222/wordpress/latest/docs).
There are also other IaC tools that can be used with Terraform.
The idomatic approach to IaC typically involves multiple tools used in combination.
However for the purposes of these examples, the focus is on terraform.

### Examples

For examples, please look at:

- [Basic server example](https://github.com/jakdept/liquidweb-terraform-example/tree/main/basic-example)
- [Basic wordpress example](https://github.com/jakdept/liquidweb-terraform-example/tree/main/simple-wordpress)

Eventually, these will be moving into [the repository for the provider](https://github.com/liquidweb/terraform-provider-liquidweb/tree/master/examples)
and will be automatically published to other locations.

More examples will also be available.
More features will also likely be added to the provider in the future as well.
Requests for specific examples will also be opened in the future.
However, first, the focus is on simplifying some of the tools.
