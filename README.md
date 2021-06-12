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
- rebar3 is highly recommended

### Hot Updates


## Where Users can Get Help with Your Project

- Email ?
- Github Issue?

## Who Maintains and Contributes to the Project

## Beware

The Gopher Protocol is inherently insecure. The communication between client and server is un-encrypted.

## Where The Project is Going

- Server side scripting without complicating the configuration for static sites.
