# QR Code Almox App

QR Code Almox App is an app designed to help in the management of a tool shelf in a construction site.

## Description

The app has a simple local login without password just so that it knows the name of the user. Login
is required in order to borrow tools from the shelf.

It uses the smartphone's camera to scan the desired tool's QR Code and infer the tool's specifications
from the local database. It then lets the user take a picture of the tools he/she wants to borrow.

A PDF file containing all the data of the lending is automatically generated. The file is saved in the
phone's local storage and, if internet connection is available, is then uploaded to a Firebase server.
All the app's functionalities were designed with the intent to allow usage even without internet connection
since it's a quite common condition in construction sites.

When it comes to return the previously borrowed tools, the user has to take at least a picture of the tools
in order to register their state and any imperfections they may have acquired. The return data is put in a
PDF file which is handled in the same way as the lending data PDF.

## Notes

This app was designed solely by Daniel Assis Carneiro, Electrical engineer in Brazil with the goal to automate
the lending and return process in a construction, saving time and gaining reliability.
