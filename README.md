# A Gopher Server 

This is a gopher server written in Erlang
allowing for hotfixes during deployment. While it is intended that the server should
be usable in production (to the extent that Gopher is usable), I am mainly maintaining the code for educational purposes.

The code is licensed under GPLv2.

## Features

- Implementation of the Gopher Protocol (RFC 1436)
- Simple Configuration

## Why the Project is Useful

Modern HTTP-webpages can be somewhat bloated. Especially the use of automatically loaded ads covering content
is annoying. 
The ability to inline links makes for sloppy document structuring.

There are plenty of Gopher Server implementations. This project aims to provide another simple configuration and
to be easily employable.

## How Users can Get Started with the Project

### Installation

- You will need a working version of Erlang installed.
- rebar3 
- Looks for configuration in ???
- 

### Hot Updates


## I need help, what should I do?

Open a Github Issue with an expressive title and a
description of your problem.

## Contribution Guide

There is no fixed code guidelines (for now). Avoid long lines, 
meaningless names and other bad coding practices.

Bug reports are welcome, please use the 

Before starting to work on a feature (which you want on this
repository)  it is probably best to open an issue beforehand.

## Beware

The Gopher Protocol is inherently insecure. The communication between client and server is un-encrypted.

## Where The Project is Going

- Server side scripting without complicating the configuration for static sites.
