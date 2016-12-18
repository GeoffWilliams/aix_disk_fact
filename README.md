# aix_disk_fact

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with aix_disk_fact](#setup)
    * [What aix_disk_fact affects](#what-aix_disk_fact-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with aix_disk_fact](#beginning-with-aix_disk_fact)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module provides support for minimal `disks` and `mountpoints` facts on the AIX platform in-lieu of built-in support in Facter (PE-18946).

## Setup

### What aix_disk_fact affects

Creates the facts:

* `disks`
* `mountpoints`
* `pe_18946`

The `disks` and `mountpoints` facts will only be modified on AIX.  The `PE_18948` fact indicates the presence and applicability of this module itself..

To enable the above facts, this module needs to be present in the environment of all AIX nodes connected to Puppet.

In the future, its anticipated that PE-18946 will address these requirements natively and at such time, you should remove this module from your systems.

## Usage

There is no configuration for this module.  Just install it and it will create the required facts.

## Reference

### Facts
* `disks`
  * Information that is normally available in the built-in `disks` fact
* `mountpoints`
  * Information that is normally available in the built-in `mountpoints` fact
* `pe_18946`
  * The presence of this fact means you can be sure that this module is installed on your puppet master
  * The fact value should be `false` on all systems that are *not* AIX
  * On AIX the fact value is an informative message

## Limitations

* AIX only
* Requires the following programs are available and in your path:
  * lspv
  * awk
  * getconf
  * lsvg
  * df
* You *must* remove this module when PE-18946 is addressed in Facter, otherwise you risk shadowing the new built-in entries from Facter with the ones from this module, which are both minimal and slow, due to shelling out to use awk, etc.

## Development
This module is a customer hotfix and as such, is not actively maintained.
