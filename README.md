# Mantle XML Adapter

This repository is a fork of the excellent [Mantle](https://github.com/github/Mantle) library that adds a MTLXMLAdapter class and some XML specific NSValueTransformer utility functions. This allows you to use XML data to create Mantle model objects in a similiar way to you would with the built in JSON support.

This is mean to be used as [Cocoapod](http://cocoapods.org) that pulls in just the XML specific implementation files, and has Mantle and KISSXML as a dependency.

There is very basic support for serializing Mantle model instances into XML, provided that the user manually constructs the DDXMLElement node tree from an instance.

## License

Mantle XML Adapter is released under the MIT license, like Mantle itself, See
[LICENSE.md](https://github.com/github/Mantle/blob/master/LICENSE.md).
