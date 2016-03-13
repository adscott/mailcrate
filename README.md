# Mailcrate

by Adam Scott [http://adams.co.tt/](http://adams.co.tt/)

## Description

A mock SMTP server loosely based on [mailtrap](http://rubymatt.rubyforge.org/mailtrap/) and [greenmail](http://www.icegreen.com/greenmail/), and can be used for automated testing. Like mailtrap, mailcrate listens on a chosen port and talks _just enough_ SMTP protocol for ActionMailer to successfully deliver a message. However, like greenmail, it is started, stopped and interogated from your test code.

## Install

```Bash
gem install mailcrate
```

## Usage

The constructor requires a single parameter, the port which it should listen on. 

```Ruby
require 'mailcrate'

mailcrate = Mailcrate.new(2525)
mailcrate.start

Mailer.send_mail(:to => 'to@example.com', :from => 'from@example.com', :body => 'An important message.')

mailcrate.mails[0][:from].should == 'from@example.com'
mailcrate.mails[0][:to_list].should include 'to@example.com'
mailcrate.mails[0][:body].should == 'An important message.'

mailcrate.stop
```

## Status

[![Build Status](https://travis-ci.org/adscott/mailcrate.svg?branch=master)](https://travis-ci.org/adscott/mailcrate)
