# Unicorn Ads | re:Invent 2018 - ARC415

![Unicorn Ads](.images/unicorn-ads.png)

Welcome to Unicorn Ads, a self-paced workshop that will teach you how to achieve multi-region database persistance for your web app that is backed by a container based backend on AWS. You will create,
verify, and test a persistant multi-region database solution on AWS. This 400 level re:Invent Builder Session is designed for developers and system architects who are familiar with Amazon Web Services, databases, backend and frontend web development, and command-line tools.

Unicorn Ads is a startup based out of the Silicon Valley that has entered the online marketplace arena.

This workshop is split into two sections outlined below. You will need to build and host the frontend user interface and the container based backend.

**Backend** - This is the container based backend API that will serve the ads to the frontend. It will also allow you to choose what database in what region the backend should be using.

**Frontend** - This is the user interface that will display the ads posted by users in the marketplace.

## Getting Started

Given that we only have one hour to setup this builder session, we will walk through setting up the container backend locally with Docker and also walking through setting up the Aurora MySQL clusters in both the Ohio and Frankfurt region.

Let us start with setting up all the backend resources. Once you have completed setting up the backend environment, you will then stand up the frontend locally and have it use the backend resources. 

**Backend**

Go [here](https://github.com/migcerva/unicorn-ads/tree/master/backend) to get started with the backend setup.

**Frontend**
Go [here](https://github.com/migcerva/unicorn-ads/tree/master/frontend) to get started with the frontend setup.

## Wrapping up
Thank you for participating in this Builder Session! Before you head out, be sure to delete all of the Aurora databases from the Ohio and Frankfurt regions to avoid any further AWS costs. Also please fill out your evaluations.
